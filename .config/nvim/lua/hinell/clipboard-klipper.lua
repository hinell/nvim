	-- if jit.os == "Linux" then
	if vim.fn.has("Linux") then
		local klipper = {}
		klipper.get = function()
			local clipboardContent = vim.system({
				"qdbus",
				"org.kde.klipper",
				"/klipper",
				"org.kde.klipper.klipper.getClipboardContents"
			}):wait()
			print("Debug: clipboardContent.stdout")
			print(vim.inspect(clipboardContent))
			return { clipboardContent.stdout, "c" }
		end

		vim.g.clipboard = {
			name = "klipper",
			copy = {
				[""]= function(lines, reg)
					print("Debug: lines")
					print(vim.inspect(lines))
				end
				, [""] = { "qdbus", "org.kde.klipper", "/klipper", "org.kde.klipper.klipper.getClipboardContents" }
			},
			paste = {
				["+"] = klipper.get,
				[""] = klipper.get
			}
		}
		vim.paste = klipper.get
	end

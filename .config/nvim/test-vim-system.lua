
		local onerror= function(err, data)
			assert(not err, err)
			print((" ->  %s"):format(err, data))
		end

		local onend = function(h)
			print("Debug: h.stdout")
			print(vim.inspect(h.stdout))
		end

		local handle = vim.system({ "which", "nvim-x" }, { text = true, detach = false, stderr = onerror }, onend)

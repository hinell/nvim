set mouse=a
" set guicursor=n-v-c-sm:ver25 ",i-ci-ve:ver25-blinkon15-blinkoff10,r-cr-o:hor20,a:Cursor/Cursor
" Set Editor Font
if exists(":GuiWindow:")
     GuiWindowOpacity 0.7
endif

" if exists(':GuiClipboard')
"  call GuiClipboard()
" endif

if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
     echo "font is set" 
    " GuiFont JetBrains\ Mono:h12
     GuiFont JetBrainsMono\ Nerd\ Font:h11

endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0 
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
" nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
" inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
" xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
" snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

map '<C-T>' :tabnew
vnoremap '<C-T>' :tabnew
" imap     '<C-S-Bs>' <ESC><Right>v<C-Left>""di
" lua vim.keymap.set({ 'i' }, '<C-Bs>', function() print("Hmmm") end)

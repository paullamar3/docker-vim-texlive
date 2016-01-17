" Plugins
call plug#begin()
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'vim-scripts/wombat256.vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
call plug#end()

" Default settings for syntastic assuming a new user.
" ---------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" End default syntastic settings. --------------------


" Colors
set t_Co=256
try
  colorscheme wombat256mod
catch
endtry

" I want line numbers
set number
" And a visible statusline
set laststatus=2

" Initially pressing Enter returns to Normal mode
" Pressing Shift-Enter (Insert mode) enters 'multiline' mode
" Pressing Shift-Enter (Insert mode) ends 'multiline' and switches to Normal mode
" Remember that we can also use Ctrl-Enter or Ctrl-j or Ctrl-m to get a new line in Insert mode.
function! ToggleEnterMapping()
  if empty(mapcheck('<CR>', 'i'))
    inoremap <CR> <Esc>`^
    return "\<Esc>"
  else
    iunmap <CR>
    return "\<CR>"
  endif
endfunction
call ToggleEnterMapping()
inoremap <expr> <F12> ToggleEnterMapping()
" Optional (so <CR> cancels prefix, selection, operator).
" nnoremap <CR> <Esc>
" vnoremap <CR> <Esc>gV
" onoremap <CR> <Esc>


set number relativenumber
set cursorline
syntax on
set tabstop=3
set laststatus=2
set noruler
set noshowcmd
set shortmess=F
set mouse=a
set noshowmode
set encoding=UTF-8
let &fcs='eob: '

set wildmenu
set wildmode=full

call plug#begin('~/.config/vim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
call plug#end()

colorscheme nord

let g:startify_custom_header =
          \ 'startify#center(startify#fortune#cowsay())'

let g:startify_fortune_use_unicode = 1

autocmd User Startified setlocal cursorline

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'component_function': {
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \ }
      \ }

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction


" Ctrl-s for saving.
" Needs in the shell: stty -ixon -ixoff
" https://github.com/tomsquest/dotfiles/
nmap <C-s> :update<CR>
vmap <C-s> <C-c>:update<CR>
imap <C-s> <C-o>:update<CR>

nnoremap <C-Insert> :tabnew<CR>
nnoremap <C-Delete> :tabclose<CR>

if &wildoptions =~ "pum"
    cnoremap <expr> <up> pumvisible() ? "<C-p>" : "<up>"
    cnoremap <expr> <down> pumvisible() ? "<C-n>" : "<down>"
endif


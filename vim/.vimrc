set number
syntax on
set tabstop=3
set laststatus=2
set noshowmode
let &fcs='eob: '

call plug#begin('~/.config/vim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
call plug#end()

colorscheme nord

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

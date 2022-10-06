let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvimpager/plugged')
   Plug 'shaunsingh/nord.nvim'
call plug#end()

colorscheme nord

"Config Section

set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:\   " fix borders
set nocompatible                                " disable compatibility to old-time vi
set showmatch                                   " show matching brackets.
set ignorecase                                  " case insensitive matching
set mouse=a                                     " middle-click paste with mouse
set hlsearch                                    " highlight search results
set tabstop=4                                   " number of columns occupied by a tab character
set softtabstop=4                               " see multiple spaces as tabstops so <BS> does the right thing
set expandtab                                   " converts tabs to white space
set shiftwidth=4                                " width for autoindents
set autoindent                                  " indent a new line the same amount as the line just typed
set number                                      " add line numbers
set noshowmode                                  " hide modes eg. -- INSERT --
set cursorline                                  " highlight current line
set termguicolors                               " enable true color
"set wildmode=longest,list                      " get bash-like tab completions
set showtabline=1                               " Show tabline
set guioptions-=e                               " Don't use GUI tabline
filetype plugin indent on                       " allows auto-indenting depending on file type
syntax on                                       " syntax highlighting

" begin COC
set hidden                                      " TextEdit might fail if hidden is not set.
set nobackup                                    " Some servers have issues with backup files, see #649.
set nowritebackup                               ""
set cmdheight=1                                 " Give more space for displaying messages.
set updatetime=300                              " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
                                                " delays and poor user experience.
set shortmess+=c                                " Don't pass messages to |ins-completion-menu|.

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  set signcolumn=number                        " Recently vim can merge signcolumn and number column into one
else
  set signcolumn=yes
endif

" end COC

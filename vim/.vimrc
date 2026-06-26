""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" VIM configuration file
"
" Sections:
"    -> Plugin manager
"    -> General settings
"    -> Theme and colors
"    -> Status line
"    -> Helper functions
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => Plugin manager
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible               " be iMproved, required
filetype off                   " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ghifarit53/tokyonight-vim'
Plugin 'kien/ctrlp.vim'
Plugin 'github/copilot.vim'
call vundle#end()              " required
filetype plugin indent on      " required


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => General settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible               " Use Vim settings, rather than Vi settings
set softtabstop=2              " Indent by 2 spaces when hitting tab
set shiftwidth=4               " Indent by 4 spaces when auto-indenting
set tabstop=4                  " Show existing tab with 4 spaces width
syntax on                      " Enable syntax highlighting
filetype indent on             " Enable indenting for files
set autoindent                 " Enable auto indenting
set number                     " Show line numbers
set nobackup                   " Disable backup files
set laststatus=2               " Show status line
set wildmenu                   " Display command line tab options as menu
set re=0                       " Use new regular expression engine
set termguicolors              " Enable true colors support
set relativenumber             " Relative line number from cursor position
set whichwrap+=<,>,h,l         " Direct cursor to previous/next line
set background=dark            " Set background to support Ayu colorscheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => Theme and colors
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => Status line
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => Helper functions
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

set nocompatible              " be iMproved, required
filetype off                  " required


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" ###################################################################
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


" Vim-Rainbow - Paranthesis Color Coordination
Plugin 'frazrepo/vim-rainbow'
let g:rainbow_active = 1
let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]
let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']

" Colorizer - Hex Color Visualization
Plugin 'lilydjwg/colorizer'

" Lightline - Status Bar
Plugin 'itchyny/lightline.vim'

" YouCompleteMe - Code Completion
Plugin 'valloric/youcompleteme'
" ###################################################################


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on

set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)
set number
set noshowmode
set nospell
set shellcmdflag=-ic
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o    " disable auto-commenting on newline

" CUSTOM SETTINGS
set laststatus=2
" redefine tabs as 2 spaces
set tabstop=2
set softtabstop=0 expandtab
set shiftwidth=2 smarttab

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif"

set termguicolors
set encoding=utf8

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"


let mapleader = " "
" <leader> + s   -->   spellchecker
:map <leader>s :setlocal spell!<CR>
" <leader> + c   -->   LaTeX compiler
:map <leader>c :!texcompile % & fg<CR><CR>

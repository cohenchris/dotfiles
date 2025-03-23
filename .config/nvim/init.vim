let mapleader = "\<Space>"

" Install vim-plug if not found
if empty(glob(expand('${XDG_DATA_HOME}/nvim/autoload/plug.vim')))
  silent !curl -fLo ${XDG_DATA_HOME}/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif


" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync
\| endif

" plug#begin does not support ${...} environment variable syntax btw
call plug#begin(expand('$XDG_DATA_HOME/nvim/plugged'))
Plug 'frazrepo/vim-rainbow'         " Vim-Rainbow - Paranthesis Color Coordination
Plug 'lilydjwg/colorizer'           " Colorizer - Hex Color Visualization
Plug 'itchyny/lightline.vim'        " Lightline - Status Bar
" Plugin 'valloric/youcompleteme'       " YouCompleteMe - Code Completion
call plug#end()

" For vim-rainbow plugin
let g:rainbow_active = 1
let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]
let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']

" if has('nvim') | let &viminfo .= '.nvim' | endif

filetype plugin indent on
syntax on
filetype on             " required
set nocompatible        " be iMproved, required
set background=dark	" dark background
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching
set incsearch           " Incremental search
set autowrite           " Automatically save before commands like :next and :make
set hidden              " Hide buffers when they are abandoned
set mouse=a             " Enable mouse usage (all modes)
set number              " Line numbers
set noshowmode          "  ...
set nospell             " ...
set shellcmdflag=-ic    " ...
set termguicolors
set encoding=utf8
set laststatus=2

" redefine tabs as 2 spaces
set tabstop=2
set softtabstop=0 expandtab
set shiftwidth=2 smarttab

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o    " disable auto-commenting on newline

" <leader> + s   -->   spellchecker
:map <leader>s :setlocal spell!<CR>
" <leader> + c   -->   LaTeX compiler
:map <leader>c :execute '!texcompile %'<CR><CR>

"""""""""" PLUGINS """"""""""
" Define base paths
let s:data = empty($XDG_DATA_HOME) ? $HOME . '/.local/share' : $XDG_DATA_HOME
let s:plug_autoload = s:data . '/nvim/autoload/plug.vim'
let s:plug_dir = s:data . '/nvim/plugged'

" Install vim-plug if missing
if !filereadable(s:plug_autoload)
  echo "Plugin manager not found! Installing now..."
  silent execute '!curl -fLo ' . shellescape(s:plug_autoload) .
        \ ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Source vim-plug
execute 'source ' . fnameescape(s:plug_autoload)

" Plugin list
call plug#begin(s:plug_dir)
  " File tree
  Plug 'preservim/nerdtree'                         " File tree (https://github.com/preservim/nerdtree)
"  Plug 'Xuyuanp/nerdtree-git-plugin'                " File tree git status flags (https://github.com/Xuyuanp/nerdtree-git-plugin)
  Plug 'ryanoasis/vim-devicons'                     " File tree icons (https://github.com/ryanoasis/vim-devicons)
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'    " File tree syntax highlighting (https://github.com/tiagofumo/vim-nerdtree-syntax-highlight)
  " Programming keyboard-related shortcuts
  Plug 'tpope/vim-surround'                         " Surrounding characters (https://github.com/tpope/vim-surround)
  Plug 'tpope/vim-commentary'                       " Commenting (https://github.com/tpope/vim-commentary)
  " Visual
  Plug 'vim-airline/vim-airline'                    " Status bar (https://github.com/vim-airline/vim-airline)
  Plug 'vim-airline/vim-airline-themes'
  Plug 'chrisbra/Colorizer'                         " CSS color highlighting (https://github.com/chrisbra/Colorizer)
  " Plug 'luochen1990/rainbow'                        " Parantheses Color Coordination
  " Programming integrations
  Plug 'sheerun/vim-polyglot'                       " Language pack (https://github.com/sheerun/vim-polyglot)
  Plug 'ms-jpq/coq_nvim'                            " Code completion
  Plug 'tpope/vim-fugitive'                         " Git integration (https://github.com/tpope/vim-fugitive)
call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync
  \| execute 'COQdeps'
\| endif


"""""""""" DEFAULT SETTINGS """"""""""
filetype plugin indent on
syntax on
filetype on             														" required
set nocompatible        														" be iMproved, required
set background=dark	    														" dark background
set showcmd             														" show (partial) command in status line.
set showmatch           														" show matching brackets.
set ignorecase          														" do case insensitive matching
set smartcase           														" do smart case matching
set incsearch           														" incremental search
set autowrite           														" automatically save before commands like :next and :make
set hidden              														" hide buffers when they are abandoned
set mouse=a             														" enable mouse usage (all modes)
set number              														" line numbers
set noshowmode          														" ...
set nospell             														" ...
set shellcmdflag=-ic    														" ...
set termguicolors       														" ...
set encoding=utf8       														" ...
set laststatus=2        														" ...
set spell               														" spell checking

" Disable auto-commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" redefine tabs as 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab


"""""""""" KEY BINDINGS  AND PLUGIN SETTINGS """"""""""
let mapleader = "\<Space>"
" General
:map <leader>s :setlocal spell!<CR>                 " <leader> + s    --> toggle spell checker
:map <leader>c :execute '!my-tex compile %'<CR><CR>   " <leader> + c   --> compile LaTeX

" NERDTree
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

"autocmd VimEnter * NERDTree | wincmd p              " open NERDTree by default
let NERDTreeShowHidden=1                            " show hidden files in NERDTree by default
nnoremap <C-n> :NERDTreeFocus<CR>                   " CTRL + n        --> focus to tree
nnoremap <C-t> :NERDTreeToggle<CR>                  " CTRL + t        --> toggle tree view
nnoremap <C-f> :NERDTreeFind<CR>                    " CTRL + f        --> find in tree
"let g:NERDTreeGitStatusUseNerdFonts = 1             " Have NERDTree git plugin use NERDFonts

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='molokai'

" COQ
g:coq_settings = { 'auto_start': 'shut-up' }

 " Colorizer
let g:colorizer_auto_filetype='*'

" VIM Surround
                                                    " cs"'  --> replace surrounding double quotes with single quotes

" VIM Commentary
                                                    " gcc   --> comment out a line
                                                    " gc    --> comment out the target of a selection
                                                    " gcgc  --> comment out a set of adjacent commented lines

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





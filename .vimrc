set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'marcweber/vim-addon-mw-utils'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/a.vim'
Plugin 'cecutil'
Plugin 'tmhedberg/matchit'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'ervandew/supertab'
Plugin 'vim-scripts/Conque-Shell'
Plugin 'vim-scripts/flymaker'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'tpope/vim-repeat'
Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/autoproto.vim'
Plugin 'vim-jp/cpp-vim'
Plugin 'vim-scripts/lodgeit.vim'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-endwise'
Plugin 'derekwyatt/vim-scala'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'fatih/vim-go'

"color scheme
Plugin 'michalbachowski/vim-wombat256mod'


call vundle#end()            " required
filetype plugin indent on    " required


"Erase disgraceful gui bits
set guioptions-=m "remove menu bar
set guioptions-=T "remove toolbar
set guioptions-=r "remove right-hand scroll bar
set guioptions-=L "remove left-hand scroll bar

"Nice variables found online:
"www.reddit.com/r/vim/comments/an9vo/what_vim_pluginscolorschemesetc_do_you_find_most/
"set font and size
set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
"set guifont=Inconsolata\ Mono\ 12
" disable vi compatibility (emulation of old bugs)
set nocompatible
" use indentation of previous line
set autoindent
" use intelligent indentation for C
"set smartindent
" configure tabwidth and insert spaces instead of tabs
set tabstop=8        " tab width is 8 spaces
set softtabstop=2 
set shiftwidth=2     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
set textwidth=89
" turn syntax highlighting on
set t_Co=256
syntax on
set cursorline "highlight line with cursor
" turn line numbers on
set number
" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */
set scrolloff=3 " Keep 3 lines below and above the cursor

" copy to the clipboard
set clipboard=unnamed

colorscheme wombat256mod
syntax enable

"Roughly Own Code
"Keyboard Mappings
"found online:
" build using makeprg with <F7>
map <F7> :make<CR>
" build using makeprg with <S-F7>
map <S-F7> :make clean all<CR>

" run a.out
map <F9> :!./a.out<CR>

" Maximize and Minimize Split
map ,<C-J> :res 1<CR>:wincmd p<CR>
map ,<C-K> <C-W>_<C-W>\|<CR>

autocmd BufRead,BufNewFile *.md set filetype=markdown

" Spell-check Markdown files
autocmd FileType markdown setlocal spell

" Spell-check Git messages
autocmd FileType gitcommit setlocal spell

" Set spellfile to location that is guaranteed to exist,
" can be symlinked to Dropbox or kept in Git
" and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

"Keyboard Mappings
"File Explorer
map <F2> :NERDTreeToggle<CR>
"List all functions and such in window
map <F3> :TlistToggle<CR>
"List all open files
map <F4> :TMiniBufExplorer<CR>
"Alternate to header file or cpp file
map ,a :A<CR>
"Force alternation
map ,A :A!<CR>

"Switch to split on down, up, left, or right
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

"Wrap in comments
:nmap Q gwap

"Other things
filetype plugin indent on
"set tags+=~/.vim/systags
"let Tlist_Auto_Open = 1
let Tlist_Use_Right_Window = 1
let g:miniBufExplMaxHeight = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchWindows = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplSplitBelow = 1
"let g:miniBufExplVSplit = 20   " column width in chars
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplForceSyntaxEnable = 1
"let Tlist_Ctags_Cmd="/bin/ctags.exe"
let g:ConqueTerm_Color = 1
let g:snips_author = 'John Hanks'

"Auto Ran Commands
"autocmd VimEnter * CMiniBufExplorer
"autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
:au FocusLost * :set number 
autocmd InsertEnter * :set number 

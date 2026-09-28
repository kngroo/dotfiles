" Install vim-plug if not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" plugins
call plug#begin()
"Color schemes
Plug 'junegunn/seoul256.vim'
Plug 'tomasr/molokai'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'w0ng/vim-hybrid'

"UI
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'othree/html5-syntax.vim'
Plug 'gregsexton/MatchTag'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle' }

"Utilities
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
" Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'scrooloose/syntastic'

call plug#end()

" BASIC SETTINGS

" map leader key to ,
let mapleader = ","
let localmaploeader = ","

" use true colors in terminal for nvim
:let $NVIM_TUI_ENABLE_TRUE_COLOR=1

:let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

syntax enable           " enable syntax processing

colorscheme seoul256
let g:molokai_original = 1
let g:seoul256_background=236
let g:seoul256_light_background=256
set background=dark
set mouse=a
set ruler

set expandtab       " tabs are spaces
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2    " number of spaces when shifting multiple lines

filetype indent on      " load filetype-specific indent files
filetype plugin on      " load filetype-specific plugins

set autoindent          " autoindent based on previous line's indentation 
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set wildmode=full
set lazyredraw          " redraw only when we need to
set laststatus=1        " persistent status bar
set showmatch           " highlight matching [{()}]
set scrolloff=2         " keep minimum buffer of 2 before/after current line

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

" space open/closes folds
nnoremap <space> za

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move 5 lines at a time
nnoremap <C-j> 5j
nnoremap <C-k> 5k

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
"nnoremap $ <nop>
"nnoremap ^ <nop>

" Q and W, function as q and w
command Q q
command W w

" highlight last inserted text
nnoremap gV `[v`]

" save session
nnoremap <leader>s :mksession<CR>

" vim-commentary
map gc <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" git gutter
nnoremap <leader>g :GitGutterToggle<CR>

" undotree
let g:undotree_WindowLayout = 2
nnoremap U :UndotreeToggle<CR>

" Goyo and limelight
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  Limelight0.8
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <leader>G :Goyo<CR>

"Color scheme selector
function! s:rotate_colors()
  if !exists('s:colors_list')
    let s:colors_list=
          \ sort(map(
          \   filter(split(globpath(&rtp, "colors/*.vim"), "\n"), 'v:val !~ "^/usr/"'),
          \   "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"))
  endif
  if !exists('s:colors_index')
    let s:colors_index = index(s:colors_list, g:colors_name)
  endif
  let s:colors_index = (s:colors_index + 1) % len(s:colors_list)
  let name = s:colors_list[s:colors_index]
  execute 'colorscheme' name
  redraw
  echo name
endfunction
nnoremap <F8> :call <SID>rotate_colors()<cr>

"Toggle relativenumber
function! s:toggle_relativenumber()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <leader>n :call <SID>toggle_relativenumber()<CR>

"NerdTree - load NerdTree if opening directory through vim
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,VimEnter *
    \   if isdirectory(expand('<amatch>'))
    \|    call plug#load('nerdtree')
    \|    execute 'autocmd! nerd_loader'
    \|  endif
augroup END

inoremap <leader>N <esc>:NERDTreeToggle<cr>
nnoremap <leader>N :NERDTreeToggle<cr>

"Tagbar
set tags=./tags;~/Development
if v:version >= 703
  inoremap <leader>T <esc>:TagbarToggle<cr>
  nnoremap <leader>T :TagbarToggle<cr>
  let g:tagbar_sort = 0
endif

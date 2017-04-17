" File: .vimrc
" Author: Ali Mousavi
" Description: My .vimrc file
" Last Modified: August 21, 2016

" -------------------- CONFIGURATIONS --------------------
" Basic settings to provide a solid base for editing.


" Don't make vim compatible with vi
set nocompatible

" make vim try to detect file types and load plugins for them
filetype plugin indent on

" turn on syntax highlighting
syntax on

" don't nag to save buffers when switching to other buffers. Just hide them.
set hidden

" automatically reload files changed outside vim
set autoread

" encoding is utf 8
set encoding=utf-8
set fileencoding=utf-8

" show keystrokes in the status line
set showcmd

" -------------------- CUSTOMIZATIONS --------------------
" extra mappings/configs to enhance my personal experience.

" set , as mapleader
let mapleader = ","

" search settings
set hlsearch         " highlight matched items.
set incsearch        " find next match as we type.
set ignorecase       " ignore case while searching.

" indentation
set shiftwidth=4     " tabs are 4 spaces
set expandtab        " use spaces instead of tabs
set autoindent      " Auto indent based on filetype
set shiftround       " round indents to a multiple of 'shiftwidth'
set softtabstop=4    " in insert mode, tabs are 4 spaces

" show line numbers.
set number

" dictionary word completion (ctrl-x ctrl-k)
set dictionary+=/usr/share/dict/words

" buffers
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" toggle between paste and nopaste with <F2>
set pastetoggle=<F2>

" type %% instead of %:h to expand the current directory of the file in
" buffer. See :h ::h
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" ZSH like suggestion
set wildmenu
set wildmode=full

" set swap files directory to avoid polluting other directories
set directory=~/.vim/swapfiles//

" hide unnecessary gui in gVim
set guioptions-=m  " remove menu bar
set guioptions-=T  " remove toolbar
set guioptions-=r  " remove right-hand scroll bar
set guioptions-=L " remove left-hand scroll bar

" -------------------- PLUGIN CONFIGURATIONS --------------------
" configurations for extra plugins.

" initiate vim-plug plugin manager.
call plug#begin('~/.vim/plugged')

" plugin definitions
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/syntastic'
Plug 'mattn/emmet-vim'
Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
Plug 'MarcWeber/vim-addon-mw-utils'    " required for snipmate
Plug 'tomtom/tlib_vim'                 " required for snipmate
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'Chiel92/vim-autoformat'
Plug 'heavenshell/vim-jsdoc'
Plug 'pangloss/vim-javascript'
Plug 'moll/vim-node'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'digitaltoad/vim-pug'
Plug 'dNitro/vim-pug-complete', { 'for': ['jade', 'pug'] }
" Add plugins to &runtimepath
call plug#end()

" theme
" colorscheme Tomorrow-Night-Eighties
colorscheme wombat256
" spelling errors style customization
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

" airline plugin
set laststatus=2                      " always load status bar
let g:airline_powerline_fonts = 1     " use powerline fonts
" display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='powerlineish'

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" file types
let g:syntastic_python_checkers = ['flake9']
let g:syntastic_css_checkers = ['csslint']
let g:syntastic_pug_checkers = ['pug_lint']

" zencoding with ctrl-e
let g:user_emmet_leader_key = '<c-e>'

" Fix snipmate trigger which conflicts with YCM
imap <C-\> <esc>a<Plug>snipMateNextOrTrigger
smap <C-\> <Plug>snipMateNextOrTrigger

" Enables syntax highlighting for JSDocs (requires vim-javascript)
let g:javascript_plugin_jsdoc = 1

" indent guides (toggle with <leader>ig)
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Temporary fix for emmet pug completion until the issue is fixed
" see: https://github.com/mattn/emmet-vim/issues/358
autocmd BufRead,BufNewFile *.pug set filetype=jade
autocmd Filetype jade set syntax=pug

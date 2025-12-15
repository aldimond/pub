" aldimond/awd.vim: Personal prefs

" Enable features
filetype plugin indent on
packadd! matchit

if &t_Co > 2 || has("gui_running")
  syntax enable
  set hlsearch
endif

" Enable my features
runtime aldimond/el.vim
runtime aldimond/qf.vim
runtime aldimond/tmux.vim
runtime aldimond/misc.vim

" UI prefs
set incsearch
set ruler
set showcmd
set wildmode=longest,list
set switchbuf=useopen

if has("mouse")
  " Disables mouse in insert mode so I can middle-click anywhere
  set mouse=nv
endif

" Check for outside changes every few seconds...
autocmd CursorHold * checktime | call feedkeys("jk")
" ... and disable the bell
set vb
set t_vb=

" Personal formatting
set expandtab
set shiftwidth=2
set softtabstop=2

" Map these to :lpr/:lne for going through search results
map <F5> :lpr<CR>
map <F6> :lne<CR>
map <F7> :cp<CR>
map <F8> :cn<CR>

" Stop the accursed Python autoindenting
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

" Makes just the current Lilypond file (expecting that a relevant makefile
" rule exists).
command MLY make -C "%:h" "%:t:r.pdf"

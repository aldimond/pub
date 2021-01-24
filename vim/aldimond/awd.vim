" aldimond/awd.vim: Personal prefs

" Enable features
filetype plugin indent on
syntax enable

" UI prefs
set incsearch
set ruler
set showcmd
set wildmode=longest,list

if has("mouse")
  " Disables mouse in insert mode so I can middle-click anywhere
  set mouse=nv
endif

" Personal formatting
set expandtab
set shiftwidth=2
set softtabstop=2

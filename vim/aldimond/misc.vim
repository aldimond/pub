
" Good style for most languages (using spaces)
function Spaces()
  set expandtab
  set shiftwidth=4
  set softtabstop=4
endfunction
command Spaces call Spaces()

" Style for languages that need tabs
function Tabs()
  set noexpandtab
  set shiftwidth&
  set softtabstop&
endfunction
command Tabs call Tabs()

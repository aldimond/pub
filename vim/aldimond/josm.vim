" aldimond/josm.vim: Settings for JOSM

runtime aldimond/qf.vim

function s:setup_josm()
  " JOSM style
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  set textwidth=100

  let &makeprg='ant $*'

  call QfAnt()
endfunction

command Josm call s:setup_josm()

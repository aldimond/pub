" TODO: make this efm str a const, use it in a command? Or append to
" errorformat?
function QfAnt()
  set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
endfunction

function _grepwhat(args)
  let cmd = 'git grep -n --column ' . a:args
  return {'lines': systemlist(cmd), 'title': cmd, 'efm': '%f:%l:%c:%m'}
endfunction

" Runs `git grep` like :grep...
function GGfunc(action, args)
  call setqflist([], a:action, _grepwhat(a:args))
  cw
endfunction

function LGGfunc(action, args)
  call setloclist(0, [], a:action, _grepwhat(a:args))
  lw
endfunction

" :GG, like :grep, uses a new QF list
command -nargs=+ GG call GGfunc(' ', <q-args>)
" :GGA, like :grepadd, appends to existing QF list
command -nargs=+ GGA call GGfunc('a', <q-args>)
" :LGG, like :lgrep, uses the curent window's location list
command -nargs=+ LGG call LGGfunc(' ', <q-args>)
" :LGGA, like :lgrepadd, appends to the location list
command -nargs=+ LGGA call LGGfunc('a', <q-args>)

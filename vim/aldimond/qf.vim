" TODO: make this efm str a const, use it in a command? Or append to
" errorformat?
function QfAnt()
  set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
endfunction

" Runs `git grep` like :grep.
function GGfunc(action, args)
  let cmd = 'git grep -n --column ' . a:args
  call setqflist([], a:action, {'lines': systemlist(cmd), 'title': cmd, 'efm': '%f:%l:%c:%m'})
  cw
endfunction
command -nargs=+ GG call GGfunc(' ', <q-args>)
command -nargs=+ GGA call GGfunc('a', <q-args>)

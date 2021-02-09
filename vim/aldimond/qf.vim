" TODO: make this efm str a const, use it in a command?
function QfAnt()
  set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
endfunction

" Runs `git grep` like :grep. This probably works.
" Pass the pattern in arg 1 (it gets `shellescape`d), then further args (raw,
" which is probably bad :-|)
function GGfunc(pat, ...)
  let cmd = 'git grep -n -e ' . shellescape(a:pat) . ' ' . join(a:000, ' ')
  call setqflist([], ' ', {'lines': systemlist(cmd), 'title': cmd, 'efm': &grepformat})
  cw
endfunction
command -nargs=+ GG call GGfunc(<f-args>)

" aldimond/el.vim: El command (opens file at line using ':' syntax)
"
" This command also accepts '-' syntax, line/char formats, trailing garbage,
" and ... generally tries to just let you select wildly

function Elfunc(fileline)
  try
    " NB: \{-} is vim's non-greedy equivalent of *
    let [foo, f, l, bar, c; baz] = matchlist(a:fileline, '\(.\{-}\)[:-]\([0-9]\+\)\([:-]\([0-9]\+\)\)\?')
    execute "e" f
    call cursor(l, c)
  endtry
endfunction
command -nargs=1 El call Elfunc(<f-args>)

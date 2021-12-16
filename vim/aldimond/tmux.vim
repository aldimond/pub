" aldimond/tmux.vim: fix tmux things

" NB: this works for vim 8.1. More advanced terminal stuff will be available
" for 8.2.
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    " ... assume I'm running tmux in a capable term as usual

    " Enable bracketed-paste mode, see :help xterm-true-color
    let &t_BE = "\<Esc>[?2004h"
    let &t_BD = "\<Esc>[?2004l"
    let &t_PS = "\<Esc>[200~"
    let &t_PE = "\<Esc>[201~"

endif

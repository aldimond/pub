# USAGE: source this, passing in PS1, PS2, error-status characters as args.

source `dirname ${BASH_SOURCE}`/colors.bash


# Defaults
c1="${1:-${PBOLD}(^_^)}"
c2="${2:-${PBRED}¯\(°_o)/¯}"
cerr="${3:-(╯°Д°)╯ ┻━┻}"


# (Optionally) last command's return code.
# NB: backtick is evaluated *after* backslash evals, so the color string can't
# be part of it (you could `echo -e` but you wouldn't get the non-printing
# character delimeters)
PS1="${PBRED}"'`a="$?" ; if [ "${a}" -ne 0 ] ; then echo "${cerr} (${a}) " ; fi`'
# Datetime
PS1+="${PBGREEN}[ \d \t ] "
# User, host
PS1+="${PBLUE}\u@\h "
# Screen/Tmux status from screen/tmux vars.
if [ -n "${STY}" ] ; then
    PS1+="${PRESET}(screen:${STY#*.}:${WINDOW}) "
elif [ -n "${TMUX}" ] ; then
    # NB: This backtick runs at source time, not PS1 eval time
    PS1+="${PRESET}(tmux:`tmux display-message -t ${TMUX_PANE} -p '#S:#I.#P'`) "
fi
# Working dir, newline
PS1+="${PBGREEN}\w\n"
# Finally, our hero
PS1+="${PRESET}${c1}${PRESET} "

# PS2: This is much easier :-)
PS2="${PRESET}${c2}${PRESET} "

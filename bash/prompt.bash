# USAGE: source this, passing in PS1, PS2, error-status characters as args.

source `dirname ${BASH_SOURCE}`/colors.bash


# Start timing at the first command after the last prompt.
trap 'test -v _awd_start || _awd_start=${EPOCHREALTIME/./}' DEBUG

# Capture return code, stop timing.
PROMPT_COMMAND=( \
    # Capture return code
    '_awd_status="$?"' \
    # Stop timing
    '_awd_t=$(( ${EPOCHREALTIME/./} - $_awd_start ))' \
    'unset _awd_start' )


# Defaults
c1="${1:-${PBOLD}(^_^)}"
c2="${2:-${PBOLD}${PROMPT_FG_RED}¯\(°_o)/¯}"
cerr="${3:-(╯°Д°)╯ ┻━┻}"


# (Optionally) last command's return code.
# NB: backtick is evaluated *after* backslash evals, so the color string can't
# be part of it (you could `echo -e` but you wouldn't get the non-printing
# character delimeters)
PS1="${PRESET}${PBOLD}${PROMPT_FG_RED}"'`if [ "${_awd_status}" -ne 0 ] ; then echo "${cerr} (${_awd_status}) " ; fi ; `'

# (Optionally) last command's run time.
PS1+="${PROMPT_FG_BLACK}"'`if [ ${#_awd_t} -gt 6 ] ; then echo "【┘】${_awd_t:0:-6}s " ; fi ; `'

# Datetime
PS1+="${PROMPT_FG_GREEN}[ \d \t ] "

# User, host
PS1+="${PRESET}${PROMPT_FG_BLUE}\u@\h "
# Screen/Tmux status from screen/tmux vars.
if [ -n "${STY}" ] ; then
    PS1+="${PRESET}(screen:${STY#*.}:${WINDOW}) "
elif [ -n "${TMUX}" ] ; then
    # NB: This backtick runs at source time, not PS1 eval time
    PS1+="${PRESET}(tmux:`tmux display-message -t ${TMUX_PANE} -p '#S:#I.#P'`) "
fi

# Working dir, newline
PS1+="${PBOLD}${PROMPT_FG_GREEN}\w\n"

# Finally, our hero
PS1+="${PRESET}${c1}${PRESET} "

# PS2: This is much easier :-)
PS2="${PRESET}${c2}${PRESET} "

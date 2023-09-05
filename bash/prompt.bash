# USAGE: source this, passing in PS1, PS2, error-status characters as args.

source `dirname ${BASH_SOURCE}`/colors.bash


# Defaults
c1="${1:-${PBOLD}(^_^)}"
c2="${2:-${PBOLD}${PROMPT_FG_RED}¯\(°_o)/¯}"
cerr="${3:-(╯°Д°)╯ ┻━┻}"


# Start timing at the first command after the last prompt.
trap 'test -v _awd_start || _awd_start=${EPOCHREALTIME/./}' DEBUG

# Use PROMPT_COMMAND to set up some stuff used in the prompt.
PROMPT_COMMAND=(
    # Capture return code, turning 0 into nothing
    '_awd_status="${?#0}"'
    # Stop timing; squash it down if <1s
    '_awd_t=$(( ${EPOCHREALTIME/./} - $_awd_start ))'
    'if [ ${#_awd_t} -gt 6 ] ; then _awd_t=${_awd_t:0:-6} ; else _awd_t= ; fi'
    'unset _awd_start'
)


PS1="${PRESET}"

# (Optionally) last command's return code.
PS1+="${PBOLD}${PROMPT_FG_RED}"'${_awd_status:+${cerr} (${_awd_status}) }'

# (Optionally) last command's run time.
PS1+="${PROMPT_FG_BLACK}"'${_awd_t:+【┘】${_awd_t}s }'

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

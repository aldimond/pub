# USAGE: source this, passing in PS1, PS2, error-status characters as args.

source `dirname ${BASH_SOURCE}`/colors.bash


# Defaults
c1="${1:-${PBOLD}(^_^)}"
c2="${2:-${PBOLD}${PROMPT_FG_RED}¯\(°_o)/¯}"
cerr="${3:-(╯°Д°)╯ ┻━┻}"


# Start timing at the first command after the last prompt.
trap 'test -v _awd_start || _awd_start=${EPOCHREALTIME/./}' DEBUG

# $1: number of seconds
# $2: unit
_awd_ft_append() {
    if [ "${_awd_t}" -ge "$1" ] ; then
        _awd_ft+=$(( _awd_t / $1 ))$2
        _awd_t=$(( _awd_t % $1 ))
    fi
}

declare -i _awd_t

# Use PROMPT_COMMAND to set up some stuff used in the prompt.
PROMPT_COMMAND=(
    # Capture return code, turning 0 into nothing
    '_awd_status="${?#0}"'
    # Stop timing; squash it down if <1s
    '_awd_t=$(( ( ${EPOCHREALTIME/./} - $_awd_start ) / 1000000 ))'
    '_awd_ft='
    '_awd_ft_append 604800 w'
    '_awd_ft_append 86400 d'
    '_awd_ft_append 3600 h'
    '_awd_ft_append 60 m'
    '_awd_ft_append 1 s'
    'unset _awd_start'
)


PS1="${PRESET}"

# (Optionally) last command's return code.
PS1+="${PBOLD}${PROMPT_FG_RED}"'${_awd_status:+${cerr} (${_awd_status}) }'

# (Optionally) last command's run time.
PS1+="${PROMPT_FG_BLACK}"'${_awd_ft:+【┘】${_awd_ft} }'

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

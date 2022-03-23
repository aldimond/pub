# USAGE: source this, passing in PS1, PS2, error-status characters as args

# Defaults (right-parens need zsh escape)
c1="${1:-%BꜺ⦒%b %%}"
c2def="%B%F{red}¯\(°_o%)/¯%b%f"
c2="${2:-$c2def}"
cerr="${3:-(╯°Д°%)╯ ┻━┻}"


# (Optionally) last command's return code. $cerr shouldn't contain any
# semicolons...
PROMPT="%B%F{red}%(?;;${cerr} (%?%) )"
# Datetime
PROMPT+="%F{green}[ %D %T ] "
# User, host
PROMPT+="%b%F{blue}%n@%m "
# Screen/Tmux status from vars.
if [ -n "${STY}" ] ; then
  PROMPT+="%f(screen:${STY#*.}:${WINDOW}) "
elif [ -n "${TMUX}" ] ; then
  PROMPT+="%f(tmux:$(tmux display-message -t ${TMUX_PANE} -p '#S:#I.#P')) "
fi
# Working dir, newline
PROMPT+="%B%F{green}%~
"
# Finally, our hero
PROMPT+="%b%f${c1} "

# PROMPT2 includes parser state, how nice
PROMPT2="${c2} (%_) "

# LOL it's a define guard
if ! [ -v _ALDIMOND_PUB_BASH_COLORS ] ; then

  # color numbers
  _BLACK=0
  _RED=1
  _GREEN=2
  _YELLOW=3
  _BLUE=4
  _MAGENTA=5
  _CYAN=6
  _WHITE=7

  _eightcolors='_BLACK _RED _GREEN _YELLOW _BLUE _MAGENTA _CYAN _WHITE'
  _colorvars=''

  for c in ${_eightcolors} ; do
    eval _FG${c}=$((${!c} + 30))
    _colorvars+=" _FG${c}"
  done

  for c in ${_eightcolors} ; do
    eval _BG${c}=$((${!c} + 40))
    _colorvars+=" _BG${c}"
  done

  for c in ${_eightcolors} ; do
    eval _FG_BRIGHT${c}=$((${!c} + 90))
    _colorvars+=" _FG_BRIGHT${c}"
  done

  for c in ${_eightcolors} ; do
    eval _BG_BRIGHT${c}=$((${!c} + 100))
    _colorvars+=" _BG_BRIGHT${c}"
  done


  # Color variables for e.g. `echo -e`. \033 sends an escape, '[' starts
  # command sequence, 'm' ends it.

  RESET='\033[0m'
  BOLD='\033[1m'
  FAINT='\033[2m'

  # TODO: remove these in favor of generated values
  BRED='\033[1;31m'
  BGREEN='\033[1;32m'
  BLUE='\033[0;34m'
  BPINK='\033[1;95m'

  # Generated
  for c in ${_colorvars} ; do
    eval ANSI${c}='"\033[${!c}m"'
  done

  # Color variables for promts. Adds non-printing delimeters '\[' and '\]' that
  # prompt vars expect.

  PRESET="\[${RESET}\]"
  PBOLD="\[${BOLD}\]"
  PFAINT="\[${FAINT}\]"

  # TODO: remove these in favor of generated values
  PBRED="\[${BRED}\]"
  PBGREEN="\[${BGREEN}\]"
  PBLUE="\[${BLUE}\]"
  PBPINK="\[${BPINK}\]"

  # Generated
  for c in ${_colorvars} ; do
    eval PROMPT${c}='"\[\033[${!c}m\]"'
  done

  _ALDIMOND_PUB_BASH_COLORS=yes
fi

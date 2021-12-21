# Color variables for e.g. `echo -e`. \033 sends an escape, '[' starts
# command sequence, 'm' ends it.
RESET='\033[0m'
BOLD='\033[1m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BLUE='\033[0;34m'
BPINK='\033[1;95m'

# Color variables for promts. Adds non-printing delimeters '\[' and '\]' that
# prompt vars expect.
PRESET="\[${RESET}\]"
PBOLD="\[${BOLD}\]"
PBRED="\[${BRED}\]"
PBGREEN="\[${BGREEN}\]"
PBLUE="\[${BLUE}\]"
PBPINK="\[${BPINK}\]"

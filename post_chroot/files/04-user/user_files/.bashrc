#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ "${TERM}" == "linux" ] && [ "${COLORTERM}" == "yes" ]; then
    CYAN="\[$(tput setaf 6)\]"
    GREEN="\[$(tput setaf 2)\]"
    RESET="\[$(tput sgr0)\]"
    PS1="${CYAN}\u${RESET} \W ${GREEN}\\\$${RESET} "
elif [ "${TERM}" == "xterm-256color" ] && [ "${COLORTERM}" == "truecolor" ]; then
    CYAN="\[$(tput setaf 6)\]"
    GREEN="\[$(tput setaf 2)\]"
    RESET="\[$(tput sgr0)\]"
    PS1="${CYAN}\u${RESET} \W ${GREEN}\\\$${RESET} "
fi

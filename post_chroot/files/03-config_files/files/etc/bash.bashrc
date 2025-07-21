#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
#export LESS='-R --use-color -Dd+r$Du+b$'
#export MANPAGER='less -R --use-color -Dd+r -Du+b'
#export MANROFFOPT='-P -c'

PS1="\u \W \$ "

if [ ${XDG_SESSION_TYPE} == "tty" ]; then
	export TERM=linux
	export COLORTERM=yes
fi

if [ ${TERM} == "linux" ] && [ ${COLORTERM} == "yes" ]; then
    GREEN="\[$(tput setaf 2)\]"
    RESET="\[$(tput sgr0)\]"
    PS1="\u \W ${GREEN}\\\$${RESET} "
elif [ ${TERM} == "xterm-256color" ] && [ ${COLORTERM} == "truecolor" ]; then
    GREEN="\[$(tput setaf 2)\]"
    RESET="\[$(tput sgr0)\]"
    PS1="\u \W ${GREEN}\\\$${RESET} "
fi

case ${TERM} in
  Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*)
    PROMPT_COMMAND+=('printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')

    ;;
  screen*)
    PROMPT_COMMAND+=('printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')
    ;;
esac

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

export HISTCONTROL="erasedups"
export HISTSIZE=500
export HISTFILESIZE=${HISTSIZE}

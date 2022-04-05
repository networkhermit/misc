# shellcheck shell=bash

set -o pipefail

# shellcheck source=/dev/null
source /etc/skel/.bashrc

###########################################################################
###########################################################################

# If not running interactively, don't do anything
case $- in
*i*)
    ;;
*)
    return
    ;;
esac

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
PROMPT_COMMAND='echo'

__exit_status () {
    x=$?
    if (( x != 0 )); then
        echo " ${x} ✘"
    fi
}

PS1='\[\033[;32m\]┌──${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)\[\033[;32m\])}(\[\033[1;34m\]\u＠\h\[\033[;32m\])-[\[\033[0;1m\]\w\[\033[;32m\]]$(__git_ps1 " (\[\033[1;36m\]%s\[\033[;32m\])")\[\033[01;31m\]$(__exit_status)\n\[\033[;32m\]└─\[\033[1;34m\]\$\[\033[0m\] '

###########################################################################

# WWWSAY
if [ -x "$(command -v cowsay)" ] && [ -x "$(command -v fortune)" ]; then
    fortune | cowsay -f www
fi

###########################################################################

bind Space:magic-space

if [ ! -r /usr/share/bash-completion/bash_completion ]; then
    complete -cf man
    complete -cf sudo
fi

if [ -x "$(command -v kubeadm)" ]; then
    # shellcheck source=/dev/null
    source <(kubeadm completion bash)
fi

if [ -x "$(command -v kubectl)" ]; then
    # shellcheck source=/dev/null
    source <(kubectl completion bash)
fi

shopt -s autocd
shopt -s histappend
shopt -s histverify

# BASIC
export EDITOR=vim
export HISTCONTROL=erasedups:ignorespace
export HISTSIZE=256
export HISTTIMEFORMAT='%F %T '
export LESSHISTFILE=-
export MANPAGER=most
export VISUAL=vim

# PATH
export PATH=${PATH}:~/STEM/bin

# ALIAS
alias acp='scp -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias ash='ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias bs="find . -type l -exec test ! -e '{}' \; -print"
alias clip='xclip -selection clip <'
alias d='cd - &> /dev/null'
alias diff='diff --color=auto'
alias ea='exa --all'
alias e='exa --classify --oneline'
alias el='exa --links --group --long --time-style long-iso'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias json='python3 -B -W:all -m json.tool --sort-keys'
alias la='ls --almost-all'
alias less='less -F'
alias ll='ls --human-readable -l --time-style long-iso'
alias l='ls --classify -1'
alias ls='ls --color=auto'
alias n='cd .; clear; fortune | cowsay -f www; date --utc "+%F %T %z" --date "now $((( (RANDOM & 1) == 0 )) && echo + || echo -) ${RANDOM} days"; history -cw; rm --force ~/.bash_history'
alias pass='echo "$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 --wrap 0 | tr --delete +/= | dd bs=32 count=1 2>/dev/null)"'
alias s='cd ..'
alias sc='shellcheck'
alias sha='sha256sum'
alias t='tree'
alias v='vim'
alias www='python3 -B -W:all -m http.server'

alias sudo='sudo '

alias unalias='true'
alias alias='true'

# PRIVACY
unset HISTFILE

###########################################################################
###########################################################################

# shellcheck shell=bash

set -o pipefail

# shellcheck disable=SC1091
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

PS1='$(EXIT_STATUS=$?; if (( EXIT_STATUS != 0 )); then printf "%s :( " "${EXIT_STATUS}"; fi)'
PS1=${PS1}'\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

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

# LIBRARY
export C_INCLUDE_PATH=~/STEM/lib/plt/c/src
export CPLUS_INCLUDE_PATH=~/STEM/lib/plt/c++/src
export GOPATH=~/STEM/lib/plt/go
export CLASSPATH=.:~/STEM/lib/plt/java/src
export NODE_PATH=~/STEM/lib/plt/nodejs/src
export PYTHONPATH=~/STEM/lib/plt/python/src
export RUBYLIB=~/STEM/lib/plt/ruby/src

# ALIAS
alias acp='scp -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias ash='ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias bs="find . -type l -exec test ! -e '{}' \; -print"
alias ccat='pygmentize -g'
alias clip='xclip -selection clip <'
alias d='cd - &> /dev/null'
alias diff='diff --color=auto'
alias e='exa --classify --oneline'
alias ea='exa --all'
alias el='exa --links --group --long --time-style long-iso'
alias grep='grep --color=auto'
alias i='echo "PIPESTATUS: ${PIPESTATUS[*]}"'
alias ip='ip -color=auto'
alias json='python3 -B -W:all -m json.tool --sort-keys'
alias k='tree'
alias l='ls --classify -1'
alias la='ls --almost-all'
alias le='exa --color auto'
alias ll='ls --human-readable -l --time-style long-iso'
alias ls='ls --color=auto'
alias n='cd .; clear; fortune | cowsay -f www; date --utc "+%F %T %z" --date "now $((( (RANDOM & 1) == 0 )) && echo + || echo -) ${RANDOM} days"; history -cw; rm --force ~/.bash_history'
alias pass='echo "$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 --wrap 0 | tr --delete +/= | dd bs=32 count=1 2>/dev/null)"'
alias s='cd ..'
alias sc='shellcheck'
alias sha='sha256sum'
alias v='vim'
alias www='python3 -B -W:all -m http.server'

alias sudo='sudo '

alias unalias='true'
alias alias='true'

# PRIVACY
unset HISTFILE

###########################################################################
###########################################################################

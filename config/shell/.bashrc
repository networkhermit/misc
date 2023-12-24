# shellcheck shell=bash

set -o pipefail

# If not running interactively, don't do anything
case $- in
*i*)
    ;;
*)
    return
    ;;
esac

if [[ -z "${TMUX}" ]] && [[ -z "${VIM}" ]]; then
    if [[ "${TERM}" = xterm-256color ]] || [[ "${TERM}" = tmux-256color ]]; then
        case ${TERM_PROGRAM} in
        Lens|vscode|zed)
            ;;
        *)
            exec tmux new-session -A -D -s main
            ;;
        esac
    fi
fi

if [[ -r /etc/skel/.bashrc ]]; then
    # shellcheck source=/dev/null
    source /etc/skel/.bashrc
fi

if [[ -x "$(command -v cowsay)" ]] && [[ -x "$(command -v fortune)" ]]; then
    fortune | cowsay -f www
fi

###########################################################################

__prompt_command () {
    echo
    if [[ -n "${TMUX}" ]]; then
        tmux set-option -p @PWD "${PWD}"
    fi
}

PROMPT_COMMAND='__prompt_command'

# shellcheck disable=SC2034
GIT_PS1_SHOWDIRTYSTATE=1
# shellcheck disable=SC2034
GIT_PS1_SHOWSTASHSTATE=1
# shellcheck disable=SC2034
VIRTUAL_ENV_DISABLE_PROMPT=1

__exit_status () {
    local x=$?
    if (( x != 0 )); then
        echo " ${x} ✘"
    fi
}

PS1='\[\033[;32m\]┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}(\[\033[1;34m\]\u＠\h\[\033[;32m\])-[\[\033[0;1m\]\w\[\033[;32m\]]$(__git_ps1 " (\[\033[1;36m\]ᚠ %s\[\033[;32m\])")\[\033[01;31m\]$(__exit_status)\n\[\033[;32m\]└─\[\033[1;34m\]\$\[\033[0m\] '

###########################################################################

HISTCONTROL=erasedups:ignorespace
HISTSIZE=256
HISTTIMEFORMAT='%F %T '
unset HISTFILE

bind Space:magic-space

set -o noclobber

shopt -s autocd
shopt -s histappend
shopt -s histverify

if [[ ! -r /usr/share/bash-completion/bash_completion ]]; then
    complete -cf man
    complete -cf sudo
fi

if [[ -x "$(command -v kubectl)" ]]; then
    # shellcheck source=/dev/null
    source <(kubectl completion bash)
fi

if [[ -x "$(command -v helm)" ]]; then
    # shellcheck source=/dev/null
    source <(helm completion bash)
fi

###########################################################################

PATH=${PATH}:~/STEM/bin

export EDITOR=vim
export LESSHISTFILE=-
export VISUAL=vim

if [[ -x "$(command -v nvim)" ]]; then
    export MANPAGER='nvim +Man!'
else
    export MANPAGER='less -R --use-color -Dd+r -Du+b'
fi

###########################################################################

alias acp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias ash='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias batdiff='git diff --diff-filter d --name-only --relative | xargs bat --diff'
alias broken-symlink="find . -xtype l -exec ls --human-readable -l --time-style long-iso '{}' +"
alias d='cd - &> /dev/null'
alias diff='diff --color=auto'
alias e='eza --classify --oneline'
alias ea='eza --all'
alias el='eza --links --group --long --time-style long-iso'
alias emacs='emacs --no-window-system'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias json='jq --sort-keys .'
alias l='ls --classify -1'
alias la='ls --almost-all'
alias less='less -F'
alias ll='ls --human-readable -l --time-style long-iso'
alias ls='ls --color=auto'
alias n='printf "\e[?1004h"; nvim'
alias pass='echo "$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 --wrap 0 | tr --delete +/= | dd bs=32 count=1 2>/dev/null)"'
alias s='cd ..'
alias sc='shellcheck'
alias sha='sha256sum'
alias t='tree'
alias v='vim'
alias www='python3 -B -W:all -m http.server'
alias yaml='yq "sort_keys(..)"'

jsonfmt () { json "${1}" | sponge "${1}"; }
yamlfmt () { yaml "${1}" | sponge "${1}"; }

if [[ $(uname -s) = Darwin ]]; then
    alias clip='pbcopy <'
else
    alias clip='xclip -selection clip <'
fi

alias sudo='sudo '

alias unalias='true'
alias alias='true'

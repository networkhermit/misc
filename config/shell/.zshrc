# shellcheck shell=bash

set -o pipefail

# If not running interactively, don't do anything
if [[ ! -o interactive ]]; then
    return
fi

if [[ -z "${TMUX}" ]] && [[ -z "${VIM}" ]]; then
    if [[ "${TERM}" = xterm-256color ]] || [[ "${TERM}" = tmux-256color ]]; then
        case ${TERM_PROGRAM} in
        vscode|Lens)
            ;;
        *)
            exec tmux new-session -A -D -s main
            ;;
        esac
    fi
fi

if [[ -r /etc/skel/.zshrc ]]; then
    # shellcheck source=/dev/null
    source /etc/skel/.zshrc
fi

if [[ -r ~/.zshrc.kali ]]; then
    # shellcheck source=/dev/null
    source ~/.zshrc.kali
fi

bindkey ^P up-line-or-history

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

precmd () {
    __prompt_command
}

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

# shellcheck disable=SC2034
PROMPT=$'%F{%(#.blue.green)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n㉿%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]$(__git_ps1 " (\e[1;36mᚠ %s\e[;32m)")%B%F{red}$(__exit_status)\n%b%F{%(#.blue.green)}└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '

###########################################################################

set -o noclobber

if [[ -x "$(command -v kubectl)" ]]; then
    # shellcheck source=/dev/null
    source <(kubectl completion zsh)
fi

if [[ -x "$(command -v helm)" ]]; then
    # shellcheck source=/dev/null
    source <(helm completion zsh)
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
alias broken-symlink="find . -xtype l -exec ls --human-readable -l --time-style long-iso '{}' +"
alias d='cd - &> /dev/null'
alias diff='diff --color=auto'
alias e='exa --classify --oneline'
alias ea='exa --all'
alias el='exa --links --group --long --time-style long-iso'
alias emacs='emacs --no-window-system'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias json='jq --sort-keys .'
alias l='ls --classify -1'
alias la='ls --almost-all'
alias less='less -F'
alias ll='ls --human-readable -l --time-style long-iso'
alias ls='ls --color=auto'
alias n='cd .; clear; fortune | cowsay -f www; date --utc "+%F %T %z" --date "now $((( (RANDOM & 1) == 0 )) && echo + || echo -) ${RANDOM} days"; history -cw; rm --force ~/.bash_history'
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

if [[ $(uname) = Darwin ]]; then
    alias clip='pbcopy <'
else
    alias clip='xclip -selection clip <'
fi

alias sudo='sudo '

alias unalias='true'
alias alias='true'

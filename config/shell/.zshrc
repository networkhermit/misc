# shellcheck shell=bash

set -o pipefail

# If not running interactively, don't do anything
if [[ ! -o interactive ]]; then
    return
fi

if [[ -z "${TMUX}" ]] && [[ -z "${VIM}" ]]; then
    if [[ "${TERM}" = xterm-256color ]] || [[ "${TERM}" = tmux-256color ]]; then
        case ${TERM_PROGRAM} in
        ghostty | vscode | zed)
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
#GIT_PS1_SHOWDIRTYSTATE=1
# shellcheck disable=SC2034
#GIT_PS1_SHOWSTASHSTATE=1
# shellcheck disable=SC2034
VIRTUAL_ENV_DISABLE_PROMPT=1
# shellcheck disable=SC2034
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

__exit_status () {
    local x=$?
    if (( x != 0 )); then
        echo " ${x} ✘"
    fi
}

# shellcheck disable=SC2034
PROMPT=$'%F{%(#.blue.green)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n@%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]$(__git_ps1 " (\e[1;36mᚠ %s\e[;32m)")%B%F{red}$(__exit_status)\n%b%F{%(#.blue.green)}└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '

###########################################################################

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

set -o noclobber

if [[ -z "${_comps[kubectl]}" ]] && [[ -x "$(command -v kubectl)" ]]; then
    # shellcheck source=/dev/null
    source <(kubectl completion zsh)
fi

if [[ -z "${_comps[helm]}" ]] && [[ -x "$(command -v helm)" ]]; then
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
alias b='b3sum'
alias batdiff='git diff --diff-filter d --name-only --relative | xargs bat --diff'
alias d='cd - &> /dev/null'
alias diff='diff --color=auto'
alias e='eza --classify --oneline'
alias ea='eza --all'
alias el='eza --links --group --long --time-style long-iso'
alias emacs='emacs --no-window-system'
alias grep='grep --color=auto'
alias json='jq --sort-keys .'
alias less='less --quit-if-one-screen'
alias n='nvim'
alias s='cd ..'
alias sc='shellcheck'
alias sha='sha256sum'
alias t='tree'
alias v='vim'
alias www='python3 -B -W:all -m http.server'
alias yaml='yq "sort_keys(..)"'

jsonfmt () { json "${1}" | sponge "${1}"; }
yamlfmt () { yaml "${1}" | sponge "${1}"; }

OS=$(uname -s)

case ${OS} in
Linux)
    alias broken-symlink="find . -xtype l -exec ls --human-readable -l --time-style long-iso '{}' +"
    alias ip='ip -color=auto'
    alias l='ls --classify -1'
    alias la='ls --almost-all'
    alias ll='ls --human-readable -l --time-style long-iso'
    alias ls='ls --color=auto'
    alias pass='dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 --wrap 0 | tr --delete +/= | dd bs=32 count=1 2>/dev/null'
    ;;
FreeBSD | Darwin)
    alias l='ls -F -1'
    alias la='ls -A'
    alias ll="ls -h -l -D '%F %R'"
    alias ls='ls -G'
    ;;
OpenBSD)
    if [[ ! -x "$(command -v nvim)" ]]; then
        unset MANPAGER
    fi
    if [[ -x "$(command -v colordiff)" ]]; then
        alias diff='colordiff'
    else
        unalias diff
    fi
    unalias grep
    alias l='ls -F -1'
    alias la='ls -A'
    alias less='less --no-init --quit-if-one-screen'
    alias ll='ls -h -l -T'
    if [[ -x "$(command -v colorls)" ]]; then
        alias ls='colorls -G'
    fi
    alias sha='sha256'
    if [[ -x "$(command -v colortree)" ]]; then
        alias tree='colortree'
    fi
    ;;
esac

case ${OS} in
Darwin)
    alias sha='shasum --algorithm 256'
    ;;
esac

case ${OS} in
FreeBSD)
    alias pass='dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 --wrap 0 | tr -d +/= | dd bs=32 count=1 2>/dev/null'
    ;;
OpenBSD)
    alias pass='dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 | tr -d "\r\n" | tr -d +/= | dd bs=32 count=1 2>/dev/null'
    ;;
Darwin)
    alias pass='dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 | tr -d +/= | dd bs=32 count=1 2>/dev/null'
    ;;
esac

case ${OS} in
Linux | FreeBSD)
    tmux-clip () {
        printf '\033]52;c;%s\a' "$(base64 --wrap 0 "${1}")" >"$(tmux display-message -p '#{client_tty}')"
    }
    ;;
OpenBSD)
    tmux-clip () {
        printf '\033]52;c;%s\a' "$(base64 "${1}" | tr -d '\r\n')" >"$(tmux display-message -p '#{client_tty}')"
    }
    ;;
Darwin)
    tmux-clip () {
        printf '\033]52;c;%s\a' "$(base64 --input "${1}")" >"$(tmux display-message -p '#{client_tty}')"
    }
    ;;
esac

case ${OS} in
Linux | FreeBSD | OpenBSD)
    case ${XDG_SESSION_TYPE} in
    wayland)
        alias clip='wl-copy <'
        ;;
    x11)
        alias clip='xclip -selection clip <'
        ;;
    *)
        if [[ -n "${TMUX}" ]]; then
            alias clip='tmux-clip'
        fi
        ;;
    esac
    ;;
Darwin)
    alias clip='pbcopy <'
    ;;
esac

unset OS

alias sudo='sudo '

alias unalias='true'
alias alias='true'

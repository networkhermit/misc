# If not running interactively, don't do anything
if ! status --is-interactive
    return
end

if command --query cowsay && command --query cowsay
    fortune | cowsay -f www
end

if [ -z "{$TMUX}" ] && [ -z "{$VIM}" ]
    if [ "{$TERM}" = xterm-256color ] || [ "{$TERM}" = tmux-256color ]
        switch {$TERM_PROGRAM}
            case Lens vscode zed
            case '*'
                exec tmux new-session -A -D -s main
        end
    end
end

###########################################################################

function __prompt_command --on-event fish_postexec
    echo
    if [ -n "{$TMUX}" ]
        tmux set-option -p @PWD {$PWD}
    end
end

#set --global __fish_git_prompt_showdirtystate 1
#set --global __fish_git_prompt_showstashstate 1

set --global fish_color_host cyan

###########################################################################

set --global fish_greeting
#set --global fish_private_mode 1
set --global fish_history ''

#if command --query kubectl
#    kubectl completion fish | source
#end

#if command --query helm
#    helm completion fish | source
#end

###########################################################################

#set --export --global PATH {$PATH} ~/STEM/bin
fish_add_path --append --path ~/STEM/bin

set --export --global EDITOR vim
set --export --global LESSHISTFILE -
set --export --global VISUAL vim

if command --query nvim
    set --export --global MANPAGER 'nvim +Man!'
else
    set --export --global MANPAGER 'less -R --use-color -Dd+r -Du+b'
end

###########################################################################

alias acp 'scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias ash 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias batdiff 'git diff --diff-filter d --name-only --relative | xargs bat --diff'
alias d 'cd - &> /dev/null'
alias diff 'diff --color=auto'
alias e 'eza --classify --oneline'
alias ea 'eza --all'
alias el 'eza --links --group --long --time-style long-iso'
alias emacs 'emacs --no-window-system'
alias grep 'grep --color=auto'
alias json 'jq --sort-keys .'
alias less 'less --quit-if-one-screen'
alias n 'printf "\e[?1004h"; nvim'
alias s 'cd ..'
alias sc shellcheck
alias sha sha256sum
alias t tree
alias v vim
alias www 'python3 -B -W:all -m http.server'
alias yaml 'yq "sort_keys(..)"'

function jsonfmt
    json {$argv[1]} | sponge {$argv[1]}
end
function yamlfmt
    yaml {$argv[1]} | sponge {$argv[1]}
end

set --local OS $(uname -s)

switch {$OS}
    case Linux
        alias broken-symlink "find . -xtype l -exec ls --human-readable -l --time-style long-iso '{}' +"
        alias ip 'ip -color=auto'
        alias l 'ls --classify -1'
        alias la 'ls --almost-all'
        alias ll 'ls --human-readable -l --time-style long-iso'
        alias ls 'ls --color=auto'
        alias pass 'echo "$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 --wrap 0 | tr --delete +/= | dd bs=32 count=1 2>/dev/null)"'
    case FreeBSD Darwin
        alias l 'ls -F -1'
        alias la 'ls -A'
        alias ll "ls -h -l -D '%F %R'"
        alias ls 'ls -G'
    case OpenBSD
        if ! command --query nvim
            set --erase MANPAGER
        end
        if command --query colordiff
            alias diff colordiff
        else
            functions --erase diff
        end
        functions --erase grep
        alias l 'ls -F -1'
        alias la 'ls -A'
        alias less 'less --no-init --quit-if-one-screen'
        alias ll 'ls -h -l -T'
        if command --query colorls
            alias ls 'colorls -G'
        end
        alias sha sha256
        if command --query colortree
            alias tree colortree
        end
end

switch {$OS}
    case Darwin
        alias sha 'shasum --algorithm 256'
end

switch {$OS}
    case FreeBSD
        alias pass 'echo "$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 --wrap 0 | tr -d +/= | dd bs=32 count=1 2>/dev/null)"'
    case OpenBSD Darwin
        alias pass 'echo "$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 | tr -d +/= | dd bs=32 count=1 2>/dev/null)"'
end

switch {$OS}
    case Linux FreeBSD OpenBSD
        switch {$XDG_SESSION_TYPE}
            case wayland
                alias clip 'wl-copy <'
            case x11
                alias clip 'xclip -selection clip <'
        end
    case Darwin
        alias clip 'pbcopy <'
end

set --erase OS

if [ "$TERM" == "screen" ]; then
    # override screen term
    export TERM=xterm-256color
fi

case "$TERM" in
xterm*|rxvt*|screen*|linux*)

    256_color () {
        # http://en.wikipedia.org/wiki/File:Xterm_color_chart.png
        echo -ne "\[\033[38;5;$1m\]";
    }

    update_title() {
        # set the window title
        printf '\033]0;%s@%s: %s\007' "$USER" "$(hostname -s)" "${PWD/$HOME/~}"
    }
    update_prompt() {
        local NOCOLOR='\[\033[0m\]'
        local GREEN='\[\033[32m\]'
        local RED='\[\033[31m\]'
        local BOLD_RED='\[\033[01;31m\]'
        local WHITE_ON_RED='\[\033[01;41m\]'
        local BLUE='\[\033[01;34m\]'
        local CYAN='\[\033[37m\]'
        local PURPLE='\[\033[01;35m\]'
        local YELLOW='\[\033[33m\]'
        local WHITE_ON_GREY='\[\033[01;40m\]'
        local GREY_ON_GREY='\[\033[40m\]'

        local ORANGE=$(256_color 215)
        local INDIGO=$(256_color 164)
        local ROOTPREFIX=''
        if [ "$(whoami)" == "root" ]; then
            ROOTPREFIX="${WHITE_ON_RED}\u${NOCOLOR}@"
        fi

        local VE=''
        if [ $VIRTUAL_ENV ]; then
            VE="${INDIGO}<$(basename $VIRTUAL_ENV)>${NOCOLOR} "
        fi

        # Show a different color host if it's a remote host vs local
        # assumes COMPUTER_NAME is set
        local HOST_COLOR=$GREEN
        if [ "$MAC_NAME" ] && [ "$MAC_NAME" = 'vincez' ]; then
            HOST_COLOR=$RED
        fi

        local MY_HOST=$HOSTNAME
        if [ "$MAC_NAME" ]; then
            MY_HOST=$MAC_NAME
        fi

        local GIT_PS1=''
        if [ $(type -t __git_ps1) ]; then
            local GIT_PS1="${ORANGE}$(__git_ps1 " %s")${NOCOLOR}"
        fi

        PS1="${VE}${ROOTPREFIX}${HOST_COLOR}${MY_HOST}${NOCOLOR}:${BLUE}\w${NOCOLOR}${GIT_PS1}\$ "
    }
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
        # Only works with Apple's Terminal.app title bar proxy icons so far
        # taken from OS X's /etc/bashrc
        local SEARCH=' '
        local REPLACE='%20'
        local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
        printf '\e]7;%s\a' "$PWD_URL"
    }
    update_ssh_auth_sock() {
        # for reattaching tmux sessions, find a working ssh-agent socket. If there's
        # more than one, just pick the first (unlikely to actually happen)
        # only do this if we're not a mac. netstat hangs there. That's ok
        # since my ssh-agent originates on a mac and I currently never
        # need it when ssh-ing to another mac.
        if [ -z "$MAC_NAME" ]; then
            local SSH_SOCK=$(find /tmp/ssh-*/agent.* -user "$USER" -type s 2>/dev/null | head -1)
            if [ -n "$SSH_SOCK" ]; then
                export SSH_AUTH_SOCK="$SSH_SOCK"
            fi
        fi
    }

    if [ -e $HOME/.bash-git-prompt/gitprompt.sh ]; then
        function prompt_callback {
            local ORANGE=$(256_color 215)
            if [ -f .terraform/environment ]; then
                echo -n " ${ORANGE}($(cat .terraform/environment))${ResetColor}"
            fi
        }
        GIT_PROMPT_SHOW_UPSTREAM=no
        GIT_PROMPT_SHOW_UNTRACKED_FILES=normal
        GIT_PROMPT_THEME=Single_line_Solarized_Lamda
        if [[ "$MAC_NAME" ]]; then
            GIT_PROMPT_THEME=Single_line_Solarized_Lamda
        else
            GIT_PROMPT_THEME=Solarized_UserHost
        fi
        source $HOME/.bash-git-prompt/gitprompt.sh
        #PROMPT_COMMAND_PREFIX="date -Ins; "
        PROMPT_COMMAND="$PROMPT_COMMAND_PREFIX $PROMPT_COMMAND; $PROMPT_COMMAND_PREFIX update_terminal_cwd; $PROMPT_COMMAND_PREFIX update_title; $PROMPT_COMMAND_PREFIX update_ssh_auth_sock; $PROMPT_COMMAND_PREFIX history -a"
    else
        # __git_ps1 options
        export GIT_PS1_SHOWDIRTYSTATE=true
        export GIT_PS1_SHOWUNTRACKEDFILES=true
        export GIT_PS1_SHOWSTASHSTATE=true
        export GIT_PS1_SHOWUPSTREAM="git, verbose"

        PROMPT_COMMAND="update_terminal_cwd; update_title; update_prompt; update_ssh_auth_sock; history -a"
    fi
    ;;
*)
    ;;
esac

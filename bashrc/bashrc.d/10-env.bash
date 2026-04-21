export EDITOR='emacs'
#if command -v emacsclient &> /dev/null; then
#    export EDITOR='TERM=xterm-24bit emacsclient -t -a vi'
#elif command -v emacs &> /dev/null; then
#    export EDITOR='emacs -nw'
#fi

# export TZ='US/Pacific'
# enable syntax highlighting for less
export LESS=' -R '

if command -v moor &> /dev/null; then
    export PAGER=moor
    export MOOR="--style=solarized-dark --quit-if-one-screen --tab-size=4 --no-clear-on-exit"
fi

export FIGNORE=\~:CVS:.svn

# If we're on a Mac, get the mac's name as set in System Preferences->Sharing->Computer Name
# can also use to detect if we're on a mac at all. If MAC_NAME is set then this is a mac
if [ -e /usr/sbin/scutil ]; then
    export MAC_NAME=$(/usr/sbin/scutil --get ComputerName)
fi

if [ "${MAC_NAME}" ]; then
    ### Java on the Mac ###
    #export JAVA_HOME=`/usr/libexec/java_home`
    # Groovy on the mac defaults to MacRoman encoding
    #export JAVA_OPTS=-Dfile.encoding=UTF-8

    #export HOMEBREW_TEMP=/var/tmp
    #export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    #export JYTHON_HOME=/usr/local/opt/jython/libexec/

    export ITERM_PANE_INDEX=$(($(echo $ITERM_SESSION_ID | sed -e "s/^.*p\(.*\):.*/\1/") - 1))
    export ITI=$ITERM_PANE_INDEX
fi

export ACK_OPTIONS="--ignore-dir=.eggs --ignore-dir=.tox"

# enable colors in `ls`
export CLICOLOR=1 # for macs
export LS_COLOR=auto # linux

export GOPATH=~/.go
append_path $GOPATH/bin

export MOSH_TITLE_NOPREFIX=1

TF_PARALLELISM=50
export TF_CLI_ARGS_plan="-parallelism=${TF_PARALLELISM}"
export TF_CLI_ARGS_apply="-parallelism=${TF_PARALLELISM}"
export TF_CLI_ARGS_destroy="-parallelism=${TF_PARALLELISM}"

# disable ctrl-s/ctrl-q nonsense
stty -ixon

if [ -f ~/.secrets.sh ]; then
    source ~/.secrets.sh
fi

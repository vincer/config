function append_path() {
    local value=$1
    local var=${2:-PATH}

    for part in $(echo ${!var} | tr ':' ' '); do
        if [ "$part" = $value ]; then
            return
        fi
    done

    if [ -z "${!var}" ]; then
        export ${var}=${value}
    else
        export ${var}=${!var}:${value}
    fi
}

function prepend_path() {
    local value=$1
    local var=${2:-PATH}

    # remove from path if already existing
    local newpath=''
    for part in $(echo ${!var} | tr ':' ' '); do
        if [ "$part" != $value ]; then
            if [ -z "${newpath}" ]; then
                newpath=${part}
            else
                newpath=${newpath}:${part}
            fi
        fi
    done
    export ${var}=${newpath}

    # prepend to path
    if [ -z "${!var}" ]; then
        export ${var}=${value}
    else
        export ${var}=${value}:${!var}
    fi
}

# Only mess with the PATH on login shells.
# non-login shells will inherit from their login shell.
if shopt -q login_shell; then
    append_path /usr/share/man MANPATH
    append_path /usr/man MANPATH
    append_path /usr/local/share/man MANPATH
    append_path /usr/kerberos/man MANPATH

    #append_path /usr/local/share/python PATH
    if which ruby >/dev/null && which gem >/dev/null && [ ! -s "$HOME/.rvm/scripts/rvm" ]; then
        #append_path /usr/local/opt/ruby/bin PATH # what was this for?

        # if we don't have rvm, add ruby's gems to PATH
        append_path "$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
    fi
    prepend_path /usr/local/bin PATH
    prepend_path /usr/local/sbin PATH

    if [ $GRADLE_HOME ]; then
        prepend_path $GRADLE_HOME/bin PATH
    fi

    # Manually find homebrew prefix to get shellenv
    if [[ -d /home/linuxbrew/.linuxbrew ]]; then
        HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
    else
        HOMEBREW_PREFIX=/opt/homebrew
    fi

    if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
        eval $($HOMEBREW_PREFIX/bin/brew shellenv)
    fi

    prepend_path $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin PATH ## To use brew's coreutils (e.g. readlink)
    prepend_path ~/.local/bin PATH
    prepend_path ~/bin PATH
fi

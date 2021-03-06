#!/bin/bash

# get referenced path of directory where this script is
DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TO_LINK="zshrc"
BACKUP=~/.zshrc.backup.`date +%F_%H%M`

for l in $TO_LINK; do
    if [ -e ~/.$l ]; then
        echo "Backing up ~/.$l to $BACKUP"
        mkdir -p $BACKUP
        cp -R ~/.$l $BACKUP
    fi
    echo "Linking $l";
    echo ""
    rm -rf ~/.$l;
    ln -sF $DIR/$l ~/.$l;
done

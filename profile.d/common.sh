#!/bin/sh

# Prepends the given path to PATH environment variable and removes duplicates
prependpath () {
    PATH="$1:${PATH}:"
    PATH="${PATH//:$1}"
    PATH="${PATH%:}"
}

# Guessing where to find the most recent Emacs
find_emacs () {
    local emacspath=$(find $@ -name emacsclient -executable -printf "%h\n" 2> /dev/null | tail -1)
    if [ -d ${emacspath} ]; then
        alias emacs="env PATH=${emacspath}:$PATH emacsclient -c"
        export VISUAL="emacs"
        export ALTERNATE_EDITOR=""
    fi
}

find_emacs $(dirname $(which emacsclient)) /usr/local/Cellar/emacs-plus/*/bin ${USERAPPL}/emacs/bin ${USERAPPL}/conda-envs/emacs/bin


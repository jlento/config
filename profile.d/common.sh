#!/bin/bash

prependpath () {
    PATH="$1:${PATH}:"
    PATH="${PATH//:$1}"
    PATH="${PATH%:}"
}

tutorial_prompt () {
    FONT_RESET=$(tput sgr0)
    FONT_BOLD=$(tput bold)
    PS1="\[${FONT_RESET}\]\w \$ \[${FONT_BOLD}\]"
    trap 'echo -ne "${FONT_RESET}" > $(tty)' DEBUG
}

export EDITOR=emacs

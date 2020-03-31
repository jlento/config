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

background () {
    local res foo
    read res foo <<<$(xrandr -q | grep '*')
    convert /projappl/project_2002239/Mulli.jpg -resize ${res}^ \
	-gravity center -extent $res -quality 90 - | display -window root -
}

export EDITOR=emacs
export -f prependpath tutorial_prompt background

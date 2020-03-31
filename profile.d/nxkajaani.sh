# .bash_profile extras for nxkajaani.csc.fi NoMachine remote desktop

# Prompt
FONT_RESET=$(tput sgr0)
FONT_BOLD=$(tput bold)
PS1="\[${FONT_RESET}\]\w \$ \[${FONT_BOLD}\]"
trap 'echo -ne "${FONT_RESET}" > $(tty)' DEBUG


# Better terminal
alias xt="printf '\e[2t'; gnome-terminal &"

# Color ls
alias ls="ls --color"

# X Background
if [[ $(hostname) =~ ^sisu.* ]]; then
    background () {
        (xview -fillscreen -onroot $1 > /dev/null &)
    }
else
    background () {
        (ssh -Y jlento@sisu.csc.fi xview -fillscreen -onroot $1 > /dev/null &)
    }
fi


# Personal configuration files


In general, I just clone this repository to `~/github/jlento/config`, and then
make soft links in HOME.

## Spacemacs


    ln -s ~/github/jlento/config/.spacemacs ~/.spacemacs

## Bash


Source custom initializations from `~/.bash_profile`, with for example by adding
line

    source ~/github/jlento/config/profile.d/osx

in OS X, or for NoMachine connections with

    if [[ $(host ${SSH_CONNECTION%% *}) =~ .*nxkajaani\.csc\.fi.* ]] \
       && [ -f ~/github/jlento/config/profile.d/nxkajaani ]; then
        source ~/github/jlento/config/profile.d/nxkajaani
    fi

## Spacemacs C IDE

First, install **clang**. If using conda in Linux, it's in package 'clangdev'.

Emacs variables you may need to touch...

    flycheck-gcc-include-path
    exec-path
    

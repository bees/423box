#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update

apt-get -y install curl

# You can install anything you need here.

apt-get install -y git cscope exuberant-ctags curl tmux vim

## Get ctags
su vagrant -c "mkdir -p ~/.cscope"

LSRC=/usr/src/linux-headers-3.19.0-25/
cd /
find $LSRC -path "$LSRC/arch/*" ! -path "$LSRC/arch/i386*" -prune -o        \
    -path "$LSRC/include/asm-*" ! -path "$LSRC/include/asm-i386*" -prune -o \
    -path "$LSRC/tmp*" -prune -o                                            \
    -path "$LSRC/Documentation*" -prune -o                                  \
    -path "$LSRC/scripts*" -prune -o                                        \
    -path "$LSRC/drivers*" -prune -o                                        \
    -name "*.[chxsS]" -print > /home/vagrant/.cscope/cscope.files

su vagrant -c "cd ~/.cscope && cscope -b -q -k"
su vagrant -c "ctags -L /home/vagrant/.cscope/cscope.files -f /home/vagrant/.tags"

## Fix some display issues with tmux
su vagrant -c "echo \"export TERM=\"screen-256color\"\" >> ~/.bashrc" # fix for weird tmux colors
su vagrant -c "echo \"alias tmux='tmux -2'\" >> ~/.bashrc" # fix for weird tmux colors

## Setup vim
su vagrant -c "curl -sfLo ~/.vimrc \
    https://raw.githubusercontent.com/bees/423box/master/dotfiles/vimrc"

su vagrant -c "curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"


su vagrant -c "vim +PlugInstall +qa > /dev/null"


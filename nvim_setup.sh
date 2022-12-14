#!/bin/bash

set -e

#Run this after neovim is installed.
#
INIT_DIR=~/.config/nvim
INIT_FILE=init.vim

CURDIR=$(pwd)
cd ~

if [ ! -d vimfiles ]; then
    echo "Cloning Doc Mike's repo."
    git clone https://github.com/drmikehenry/vimfiles
    echo "Creating symlink to ~/vimfiles as .vim"
    ln -s ~/vimfiles .vim
fi

echo "Add VIMUSERLOCALFILES=path/to/vimlocal to .bashrc"

echo "Creating $INIT_DIR/$INIT_FILE"
mkdir -p $INIT_DIR

init="\
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc"
echo "$init" > $INIT_DIR/$INIT_FILE

echo "Done."



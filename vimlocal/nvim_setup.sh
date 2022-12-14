#!/bin/bash

set -e

#Run this after neovim is installed.
#
INIT_DIR=~/.config/nvim
INIT_FILE=init.vim

CURDIR=$(pwd)
cd ~
echo "Cloning Doc Mike's repo."
git clone https://github.com/drmikehenry/vimfiles
echo "Creating symlink to ~/vimfiles as .vim"
ln -s ~/vimfiles .vim

echo "Add VIMUSERLOCALFILES=~/linuxconfig/vimlocal to .bashrc"
export VIMUSERLOCALFILES=~/linuxconfig/vimlocal

echo "Creating $INIT_DIR/$INIT_FILE"
mkdir -p $INIT_DIR

init="\
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc"
echo "$init" > $INIT_DIR/$INIT_FILE

echo "Creating .vimrc file in ~."
echo "runtime vimrc" > ~/.vimrc

echo "Done."



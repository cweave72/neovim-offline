#!/bin/bash

set -e

echo INSTALL_PREFIX = ${INSTALL_PREFIX:=/opt}
echo RELEASE = ${RELEASE:=0.8.1}
echo EXTRACT_DIR = ${EXTRACT_DIR:=.}

ARCHIVE_FILE=nvim-linux64

echo "Extracting $ARCHIVE_FILE.tar.gz"
tar xf releases/$RELEASE/$ARCHIVE_FILE.tar.gz --directory=$EXTRACT_DIR

if [ ! -z ${EXTRACT_ONLY+x} ]; then
    echo "Extract only set."
    exit
fi

PREFIX=$INSTALL_PREFIX/nvim/$RELEASE

read -p "Are you sure you want to install to $PREFIX? " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo Aborting.
    exit
fi

echo "Installing to $PREFIX"

rm -rf $PREFIX
mkdir -p $PREFIX

CP_SRC=$EXTRACT_DIR/$ARCHIVE_FILE

cp -r $CP_SRC/bin $PREFIX
cp -r $CP_SRC/share $PREFIX
cp -r $CP_SRC/lib $PREFIX

echo "Successfully installed to $PREFIX."

echo "Add the following lines to your .bashrc:"
echo "-----"
echo "NVIM_PATH=$PREFIX"
echo "export PATH=\$NVIM_PATH/bin:\$PATH"
echo "-----"

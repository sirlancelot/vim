#!/bin/bash

RCDIR=$(pwd)
NOW=$(date +%s)

cd "$HOME"
if [ -f .vimrc -a ! -h .vimrc ]; then
	echo Backing up old vimrc...
	mv .vimrc .vimrc-saved-$NOW
fi

echo Linking new vimrc...
ln -sf .vim/vimrc.vim .vimrc

cd "$RCDIR"

git submodule update --init

#!/bin/bash

RCDIR=$HOME/.vim
NOW=$(date +%s)

cd "$HOME"
if [ -f .vimrc -a ! -h .vimrc ]; then
	echo "Backing up old vimrc..."
	mv .vimrc .vimrc-saved-$NOW
fi

echo "Linking new vimrc..."
ln -sf .vim/vimrc.vim .vimrc

cd "$RCDIR"

echo "Initializing submodules..."
git submodule update --init

if [ ! -f vimrc.local.vim ]; then
	echo "Copying sample local vimrc..."
	cp extra/vimrc.local.sample vimrc.local.vim
	echo "You can now open and customize ~/.vim/vimrc.local.vim"
fi

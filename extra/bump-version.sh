#!/bin/bash

VERSION=$1

if [ -z $VERSION ]; then
	echo "Specify verison to bump to."
	exit 1
fi

for File in *vimrc.vim; do
	echo "Bumping version number in $File..."
	sed -e "s/^\(\" Version: \)v.*$/\1v$VERSION/" $File > $File~
	mv $File~ $File
done

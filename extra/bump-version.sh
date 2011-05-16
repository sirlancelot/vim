#!/bin/sh

GITROOT=$(git rev-parse --show-toplevel)

usage() {
	echo "usage: $0 <version>"
}

Version=$1

if [ -z $Version ]; then
	usage
	exit 1
fi

cd "$GITROOT"
for File in *vimrc.vim; do
	echo "Bumping version number in $File..."
	if ! sed "s/^\(\" Version: \)v.*$/\1v$Version/" "$File" > "$File~"; then
		echo "Could not replace Version in $File." >&2
		exit 2
	fi
	mv "$File~" "$File"
	git add "$File"
done

git commit -m "Bumped version to v$Version"

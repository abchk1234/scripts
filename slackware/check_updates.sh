#!/bin/bash
# check_updates.sh

PRG='./check_updates'

if [[ $1 = -h ]]; then
	echo "Usage: $PRG [-ch]"
	echo "$PRG -ch option opens links in browser for checking."
	exit
fi

for dir in $(find /home/aaditya/builds -type d -maxdepth 1 ! -name "builds"); do
	pkg=$(basename "$dir")
	if [[ $pkg = MINE ]] || [[ $pkg = EXTRA ]]; then
		continue
	fi
	cd "$dir"; cd "$pkg"
	#pwd; ls
	source ./${pkg}.info
	echo "$pkg $VERSION"
	if [[ $1 = -ch ]]; then
		xdg-open "$HOMEPAGE"
	else
		echo "$HOMEPAGE"
		echo
	fi
done

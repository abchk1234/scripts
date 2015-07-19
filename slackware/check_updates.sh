#!/bin/bash
# check_updates.sh

for dir in $(find /mnt/datalinux2/slackware/builds -type d -maxdepth 1 ! -name "builds"); do
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

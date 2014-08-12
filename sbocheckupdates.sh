#!/bin/bash
# Script to open info files in the builds folder in browser to check for updates

for i in /home/aaditya/builds/*; do
	echo $i
	if [ -d $i ]; then
		cd $i
		ls
		echo $(basename $i)
		cd $(basename $i)
		direc=$(basename $i)
		if [ -f $direc.info ]; then
			. $i.info
			xdg-open $HOMEPAGE
		fi
	fi
done

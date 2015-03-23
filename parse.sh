#!/bin/bash
# parse.sh: a script to parse the contents of a file, ie,
# ignore comments and blank lines

file="$1"	# file is specified as first cmd line arg

if [ -z "$file" ]; then
	echo "file not specified" && exit 1
fi

while read p; do
	if [ -z "$p" ]; then
		continue
	elif [ "$(echo $p | cut -c 1)" == "#" ]; then
		continue
	else
		echo $p
	fi
done < $file

# Return exit status
exit $?

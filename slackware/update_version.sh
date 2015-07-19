#!/bin/sh
# update_version.sh

# we are searching current directory so 
cwd=$(pwd)
path="$cwd"

get_info() {
	# get the name of the package
	package=$(basename $(find -L "$path" -name "*.info" -printf "%p\n") | cut -f 1 -d ".")
	if [ -z "$package" ]; then
		echo " unable to process $package; .info not found."
		exit 1
	else
		. "$path/$package.info"
		echo "$path/$package.info sourced."
	fi
}

get_info

old_ver=$VERSION
new_ver=$1

if [ -z $old_ver ]; then
	echo "old version not specified"
	exit 1
elif [ -z $new_ver ]; then
	echo "old version not specified"
	exit 1
fi

for file in $package.info $package.SlackBuild; do
	sed "s|$old_ver|$new_ver|g" -i "$path/$file"
	echo "Version $old_ver replaced with $new_ver in $file"
done

exit $?

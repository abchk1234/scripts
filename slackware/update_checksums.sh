#!/bin/bash
# updatechecksums.sh: check and update md5sums in $package.info

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

#get-info () {
	# get the name of the package
#	if [ -f "$path"/*.info ]; then
#		package=$(find "$path" -name "*.info" -printf "%p\n" | cut -f 1 -d ".")
#	else
#		echo " unable to process $package; .info not found."
#		exit 1
#	fi
	# source the .info file to get the package details
#	if [[ -f "$path/$package.info" ]]; then
#		. "$path/$package.info"
#		echo "$path/$package.info sourced."
#	else
#		echo "$package.info in $path n/a"
#		exit 1
#	fi
#}

get_source_data() {
	get_info
	# Check special cases where the package has a separate download for x86_64
	if [[ $(uname -m) == "x86_64" ]] && [[ -n "$DOWNLOAD_x86_64" ]]; then
		link="$DOWNLOAD_x86_64"
	else
		link="$DOWNLOAD"
	fi

	src=$(basename "$link")	# Name of source file
	
	# Check for source in various locations
	if [ -e "$path/$src" ]; then
		md5=$(md5sum "$path/$src" | cut -f 1 -d " ")
	else
		echo "md5sum could not be calculated; src not found"
		exit 1
	fi
}

get_source_data

# Now update the .info file
if [[ $(uname -m) = x86_64 ]] && [[ -n $DOWNLOAD_x86_64 ]]; then
	sed -i "s|MD5SUM_x86_64=.*|MD5SUM_x86_64=\"${md5}\"|" $package.info
	echo "MD5SUM_x86_64 updated in $package.info"
	echo "previous: $MD5SUM_x86_64"
	echo "new: $md5"
else
	sed -i "s|MD5SUM=.*|MD5SUM=\"${md5}\"|" $package.info
	echo "MD5SUM updated in $package.info"
	echo "previous: $MD5SUM"
	echo "new: $md5"
fi

# Done
exit 0

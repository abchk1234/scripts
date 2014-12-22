#!/bin/bash
# modules-load.sh: copy the modules in /etc/modules-load.d/* to /etc/conf.d/modules and modprobe them
##
#  Copyright (C) 2014 Aaditya Bagga (aaditya_gnulinux@zoho.com)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  any later version.
#
#  This program is distributed WITHOUT ANY WARRANTY;
#  without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the GNU General Public License for more details.
##

# /etc/modules-load.d/ is a directory which contains files (ending with .conf), which specify the modules to be loaded.

# However, openrc loads modules specified in the file /etc/conf.d/modules (by parsing the variable modules=""

# This script aims to copy the modules specified in individual files in /etc/modules-load.d/* to a single modules variable in /etc/conf.d/modules
# and load (modprobe) them

# Display some help text
#if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
if [ -n "$1" ]; then
	echo "modules_load: compatability modules loader for openrc"
	echo "reads from /etc/modules-load.d/* to /etc/conf.d/modules"
	echo "syntax: modules_load (takes no command line arguments)"
	exit 0
fi

modules_loc="/etc/modules-load.d"
openrc_mod="/etc/conf.d/modules"

# Read modules by parsing  $openrc_loc
if [ -e "$openrc_mod" ]; then
	source "$openrc_mod"
else
	echo "$openrc_mod not found"
	exit 1
fi

# Process the modules from /etc/modules-load.d/*
process_module () {
	# This function accepts a module as argument, checks if that module
	# is already present in the modules variable, if not, adds it

	new_module="$1" # module to be checked specified as first argument

	if [ ! "$(echo $modules | grep "$new_module")" ]; then
		# Load this module
		modprobe "$new_module"
		# Supplement the modules variable with this new module
		modules+=" $new_module"
	fi
}

# Main loop
for i in $(ls /etc/modules-load.d/); do
	while read -r p; do
		# Check for blank lines and comments
		if [ -z "$p" ]; then
			continue  # skip this loop instance
		elif [ "$(echo "$p" | cut -c 1)" == "#" ]; then
			continue  # skip this loop instance
		else
			process_module "$p"
		fi
	done < "$modules_loc/$i"
done

# Write the modified modules back to $openrc_mod
sed -i "s/modules=.*/modules=\"${modules}\"/" "$openrc_mod"

# Done
exit 0

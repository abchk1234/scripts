#!/bin/bash
# modules-load.sh: copy the modules in /etc/modules-load.d/* to /etc/conf.d/modules

# /etc/modules-load.d/ is a directory which contains files (ending with .conf), which specify the modules to be loaded.

# However, openrc loads modules specified in the file /etc/conf.d/modules (by parsing the variable modules=""

# This script aims to copy the modules specified in individual files in /etc/modules-load.d/* to a single modules variable in /etc/conf.d/modules

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
		# supplement the modules variable with this new module
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
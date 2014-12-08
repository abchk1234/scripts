#!/bin/bash
# Check updates to SBo packages

# Update the local repository and display changelog
asbt -u && asbt -C

# variables
count=1
total=$(asbt -c | cut -f 1 -d ":" | wc -l)

# Check for updates, view readme and process them
for i in $(asbt -c | cut -f 1 -d ":"); do 
	echo "--------------------------------------------------"
	echo "$i ($count of $total)" # package name and no
	echo "--------------------------------------------------"
	asbt -r $i
	echo "Press any key to continue..." && read x # pause
	asbt -P $i 
done

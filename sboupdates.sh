#!/bin/bash
# Check updates to SBo packages

# Update the local repository
asbt -u

# Check for updates and process them
for i in $(asbt -c | cut -f 1 -d ":"); do 
	asbt -P $i 
done

#!/bin/bash
# check_orphans.sh

# Sync sbbdep's database first
sbbdep || exit 1

# Check all installed packages, barring those from SBo
for package in /var/adm/packages/*; do
	if [[ ! $(echo $package | grep SBo) ]]; then
		#echo "Checking $package"
		out=$(sbbdep --nosync --whoneeds $package) #> /dev/null || echo "Possible Orphan $package"
		[[ -z "$out" ]] && echo "Possible Orphan $package"
	fi
done

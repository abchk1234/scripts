#!/bin/bash
# clean-slackpkg-cache

CACHE_DIR="/var/cache/packages"
DAYS_TO_KEEP=30
FILES_TBD=()
TOTAL_FILE_SIZE=0
DRY_RUN=true

# Handle cmd line options
while getopts "d:nqh" opt
do
	case "$opt" in
	d) DAYS_TO_KEEP="$OPTARG";;
	n) DRY_RUN=false;;
	q) QUIET=0;;
	*) ;;
	esac
done

FILES_TBD=($(find "$CACHE_DIR" -type f -mtime +"$DAYS_TO_KEEP"))

for file in "${FILES_TBD[@]}"; do
	#echo "$file"
	file_name=$(echo "$file" | rev | cut -f 1 -d "/" | rev)
	file_path=$(echo "$file" | sed "s|/var/cache/packages||" | cut -f 2- -d "/" | rev | cut -f 2- -d "/" | rev)
	file_size=$(du "$file" | cut -f 1)
	TOTAL_FILE_SIZE=$(( TOTAL_FILE_SIZE + file_size ))
	if [ $DRY_RUN = 'false' ]; then
		rm -v "$file"
	fi
done

# remove empty dirs
if [ $DRY_RUN = 'false' ]; then
	echo "empty directories"
	find "$CACHE_DIR" -type d -empty -print -delete
fi

echo "space to be cleared: $TOTAL_FILE_SIZE kb"

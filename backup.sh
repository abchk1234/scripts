#!/bin/bash
# backup.sh: System backup using rsync

# Arguments:
# $1: Destination path
# $2: Source path (defaults to /)

if [ $# -lt 1 ]; then 
    echo "No destination defined. Usage: $0 destination" >&2
    exit 1
elif [ $# -gt 2 ]; then
    echo "Too many arguments. Usage: $0 destination" >&2
    exit 1
elif [ ! -d "$1" ]; then
   echo "Invalid path: $1" >&2
   exit 1
elif [ ! -w "$1" ]; then
   echo "Directory not writable: $1" >&2
   exit 1
fi

case "$1" in
  "/mnt") ;;
  "/mnt/"*) ;;
  "/media") ;;
  "/media/"*) ;;
  "/run/media/"*) ;;
  *) echo "Destination not allowed." >&2 
     exit 1 
     ;;
esac

src=${2:-""}

START=$(date +%s)

rsync -aAXv --delete-after ${src}/* $1 --exclude={${src}/dev/*,${src}/proc/*,${src}/sys/*,${src}/tmp/*,${src}/run/*,${src}/mnt/*,${src}/media/*,${src}/lost+found,${src}/swapfile,${src}/var/lib/pacman/sync/*,${src}/home/aaditya/DataLinux/*,${src}/home/*/.thumbnails/*,${src}/home/*/.mozilla/firefox/*.default/cache/*,${src}/home/*/.thunderbird/*.default/ImapMail/*,${src}/var/log/journal/*,${src}/home/aaditya/src/kernel/*,${src}/home/*/.cache/*,${src}/root/.cache/*,${src}/home/*/.gvfs,${src}/*/.cache/*,${src}/*/.thumbnails/*,${src}/root/.ccache/*,${src}/home/*/.local/share/Trash/*}

status=$?

FINISH=$(date +%s)

# Reporting
content_to_write="total time: $(( (FINISH - START) / 60 )) minutes, $(( (FINISH - START) % 60 )) seconds"
if [ "$status" -eq 0 ]; then
	mkdir -p "$1/backup"
	echo "$content_to_write" | tee "$1/backup/Backup-from-$(date '+%Y-%B-%d-%A-%T')"
	# same needs to be present in source as well or it will be deleted on next sync!
	mkdir -p "$src/backup"
	echo "$content_to_write" | tee "$src/backup/Backup-from-$(date '+%Y-%B-%d-%A-%T')"
fi

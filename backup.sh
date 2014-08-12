#!/bin/sh

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

src="$2"
#src=${2:-"/"}

START=$(date +%s)
rsync -aAXvC -H -h --delete "$src"/* $1 --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/var/lib/pacman/sync/*,/home/aaditya/DataLinux/*,/home/*/.thumbnails/*,/home/*/.mozilla/firefox/*.default/Cache/*,/home/aaditya/work*,/var/log/journal/*,/home/aaditya/src/kernel/*,/home/*/.cache/*,/root/.cache/*}
FINISH=$(date +%s)
 
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds" | tee $1/"Backup from $(date '+%A, %d %B %Y, %T')"

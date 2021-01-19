#!/bin/bash
# backup.sh: System backup using rsync

SRCDIR=""
DESTFS="unix"

# cmd line args
while getopts "d:s:w" opt; do
  case $opt in
    d)
      DESTDIR=$OPTARG
      ;;
    s)
      SRCDIR=$OPTARG
      ;;
    w)
      DESTFS="windows"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ -z "$DESTDIR" ]; then
    echo "No destination defined. Usage: $0 -d destination" >&2
    exit 1
elif [ ! -d "$DESTDIR" ]; then
   echo "Invalid path: $DESTDIR" >&2
   exit 1
elif [ ! -w "$DESTDIR" ]; then
   echo "Directory not writable: $DESTDIR" >&2
   exit 1
fi

case "$DESTDIR" in
  "/mnt") ;;
  "/mnt/"*) ;;
  "/media") ;;
  "/media/"*) ;;
  "/run/media/"*) ;;
  *) echo "Destination not allowed." >&2 
     exit 1 
     ;;
esac

START=$(date +%s)

# TODO: Windows incremental sync maybe broken
# TODO: Find out better rsync command that does not involve listing all the source dirs on cmd line
# TODO: add cmd line args and output to debug commands being run

if [ "$DESTFS" = unix ]; then
  rsync -aAXv --delete-after "${SRCDIR}"/* "$DESTDIR" --exclude={/dev/*,/proc/*,/sys/*,/run/*,/mnt/*,/media/*,/lost+found,/swapfile,/home/*/.gvfs}
elif [ "$DESTFS" = windows ]; then
  # for ntfs and fat
  ##rsync -vrc --delete --progress --no-p ${SRCDIR}/* $DESTDIR
  rsync -vr --no-p --modify-window=1 --delete-after "${SRCDIR}"/* "$DESTDIR" --exclude={"\$RECYCLE.BIN/","System Volume Information/"}
else
  echo "Invalid destination filesystem"
  exit 1
fi

status=$?

FINISH=$(date +%s)

# Reporting
content_to_write="total time: $(( (FINISH - START) / 60 )) minutes, $(( (FINISH - START) % 60 )) seconds"
time_to_write="$(date '+%Y-%B-%d-%A-%T' | sed 's/:/_/g')"
if [ "$status" -eq 0 ]; then
	mkdir -p "$DESTDIR/backup"
	echo "$content_to_write" | tee "$DESTDIR/backup/Backup-from-${time_to_write}"
	# same needs to be present in source as well or it will be deleted on next sync!
	mkdir -p "$SRCDIR/backup"
	echo "$content_to_write" | tee "$SRCDIR/backup/Backup-from-${time_to_write}"
fi

#!/bin/sh
# https://www.linuxquestions.org/questions/showthread.php?p=5380431

set -e

SLKVER=${1:-64-current}
LOGDIR="$HOME/.slackware.ChangeLog/$SLKVER"
LOGNEW="$LOGDIR/ChangeLog.txt"
LOGOLD="$LOGDIR/ChangeLog.txt.old"

mkdir -p "$LOGDIR"
[ ! -e "$LOGOLD" ] && touch "$LOGOLD"

wget -q -N -P "$LOGDIR" "ftp://ftp.osuosl.org/pub/slackware/slackware$SLKVER/ChangeLog.txt"

DIFF=$(diff -wiBaE "$LOGOLD" "$LOGNEW" | grep "^>" | cut -b 3-)

if [ "$DIFF" ]; then
        echo "slackware$SLKVER ChangeLog:"
        echo "+--------------------------+"
        echo "$DIFF"
        cp "$LOGNEW" "$LOGOLD"
fi

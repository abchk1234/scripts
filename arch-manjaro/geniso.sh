#!/bin/bash
# geniso.sh: generate ISO using buildiso, removing local repo from pacman.conf

REPO=openrc-eudev
WORKDIR=/opt/buildiso
ARCH=$(uname -m)
QUERY=false

# Check for root
if [[ $EUID -ne 0 ]]; then
	echo "Must be run as root."
	exit 1
fi

# Get the profile and arch
while getopts "p:a:b:r:wcxlisqh" opt
do
	case "$opt" in
	p) PROFILE="$OPTARG";;
	a) ARCH="$OPTARG";;
	r) WORKDIR="$OPTARG";;
	q) QUERY=true;;
	*) ;;
	esac
done

# Build the profile chroot
buildiso "$@" -i

# Remove the repo from pacman.conf
for file in $WORKDIR/$PROFILE/$ARCH/{livecd,root,${PROFILE%-*}}-image/etc/pacman.conf
do
	if [[ -f $file ]] && [[ ! $QUERY = true ]]; then
		echo "Editing $file"
		sed -i "/^\[$REPO/,/^Server/d" "$file" || exit 1
	fi
done

# Build iso
buildiso "$@" -sc

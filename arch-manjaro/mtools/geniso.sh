#!/bin/bash
# geniso.sh: generate ISO using buildiso, removing local repo from pacman.conf
# Inspired from https://forum.manjaro.org/index.php?topic=20637.msg186815#msg186815

# Set defaults
WORKDIR=/var/lib/manjaro-tools/buildiso
ARCH=$(uname -m)
QUERY=false
REPOS=()
PROFILEDIR="/home/aaditya/manjaro-tools-iso-profiles"

# Check for root
if [[ $EUID -ne 0 ]]; then
	echo "Must be run as root."
	exit 1
fi

# Source for pre and post_install tasks
source /home/aaditya/mtools/pre-install || exit 1
source /home/aaditya/mtools/post-install || exit 1

# Colors
BOLD="\e[1m"
CLR="\e[0m"
GREEN="\e[1;32m"

# Get profile, arch and other options
while getopts "p:a:b:r:t:cisvqh" opt
do
	case "$opt" in
	p) PROFILE="$OPTARG";;
	a) ARCH="$OPTARG";;
	r) WORKDIR="$OPTARG";;
	q) QUERY=true;;
	*) ;;
	esac
done

# Profile is in community folder
COMMUNITY_PROFILE="community/${PROFILE}"

# Pre install
if [[ ! $QUERY = true ]]; then
	pre_install
	echo -e "${BOLD}${GREEN}" "Pre-install tasks done." "$CLR"
fi

# Build the profile chroot
if [[ $@ != *-sc* ]] && [[ ! $QUERY = true ]]; then
	buildiso "$@" -i
fi

# Post install
if [[ ! $QUERY = true ]]; then
	echo -e "${GREEN}${BOLD}" "Performing custom tasks." "$CLR"
fi

# Remove extra stuff from pacman.conf
flag=0
for file in $WORKDIR/$PROFILE/$ARCH/{livecd,root,${PROFILE%-*}}-image/etc/pacman.conf
do
	if [[ -f $file ]] && [[ ! $QUERY = true ]]; then
		echo "Editing $file"
		sed '/XferCommand = \/usr\/bin\/wget --passive-ftp -c -q --show-progress -O %o %u/ d' -i "$file" && flag=1 || exit 1
	fi
done
if [[ $flag -eq 1 ]]; then
	echo -e "${BOLD}${GREEN}" "Custom wget command removed from pacman.conf" "$CLR"
fi

# Change branch to stable in pacman-mirrors.conf
flag=0
for file in $WORKDIR/$PROFILE/$ARCH/{livecd,root,${PROFILE%-*}}-image/etc/pacman-mirrors.conf; do
	if [[ -f $file ]] && [[ ! $QUERY = true ]]; then
		echo "Editing $file"
		sed 's|Branch=.*|Branch=stable|' -i "$file" && flag=1 || exit 1
	fi
done
if [[ $flag -eq 1 ]]; then
	echo -e "${BOLD}${GREEN}" "Branch set to stable in pacman-mirrors.conf" "$CLR"
fi

# Perform post installation tasks
if [[ ! $QUERY = true ]]; then
	post_install
	echo -e "${BOLD}${GREEN}" "Post-install tasks done." "$CLR"
fi

# Build iso
buildiso "$@" -sc

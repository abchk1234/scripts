#!/bin/bash
# geniso.sh: generate ISO using buildiso, removing local repo from pacman.conf
# Inspired from https://forum.manjaro.org/index.php?topic=20637.msg186815#msg186815

# Set defaults
WORKDIR=/var/lib/manjaro-tools/buildiso
ARCH=$(uname -m)
QUERY=false
REPOS=()

# Check for root
if [[ $EUID -ne 0 ]]; then
	echo "Must be run as root."
	exit 1
fi

# Source for post_install tasks
source /home/aaditya/mtools/post-install || exit 1

# Colors
BOLD="\e[1m"
CLR="\e[0m"
GREEN="\e[1;32m"

# Get profile, arch and other options
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

get_repos () {
	# get repos from pacman.conf specified as argument
	local pacman_conf=$1
	# sed is being used for filtering comments and repo brackets []
	REPOS=($(grep "\[*\]" "$pacman_conf" | sed -e '/^\s*#/d' -e 's/\[//' -e 's/\]//'))
}

# Get repos from pacman.conf and set valid repos
if [[ $ARCH = x86_64 ]]; then
	VALID=('options' 'core' 'extra' 'community' 'multilib')
	# Get list of repos
	if [[ -e $PROFILE/pacman-multilib.conf ]]; then
		get_repos "$PROFILE/pacman-multilib.conf"
	fi
else
	VALID=('options' 'core' 'extra' 'community')
	# Get list of repos
	if [[ -e $PROFILE/pacman-default.conf ]]; then
		get_repos "$PROFILE/pacman-default.conf"
	fi
fi

# Pre-install
if [[ ! $QUERY = true ]]; then
	rm -v /var/cache/pacman/pkg/tlp-pmu-*-any.pkg.tar.xz
	rm -v /var/cache/pacman/pkg/openresolv-openrc-*-any.pkg.tar.xz
fi

# Build the profile chroot
if [[ $@ != *-sc* ]] && [[ ! $QUERY = true ]]; then
	buildiso "$@" -i
fi

echo -e "${GREEN}${BOLD}" "Performing custom tasks." "$CLR"

# Remove extra repos from pacman.conf
flag=0
for repo in "${REPOS[@]}"; do
	if ! echo "${VALID[*]}" | grep -q "$repo"; then
		# Remove custom repo
		for file in $WORKDIR/$PROFILE/$ARCH/{livecd,root,${PROFILE%-*}}-image/etc/pacman.conf
		do
			if [[ -f $file ]] && [[ ! $QUERY = true ]]; then
				echo "Editing $file"
				sed -i "/^\[$repo/,/^Server/d" "$file" && flag=1 || exit 1
			fi
		done
		if [[ $flag -eq 1 ]]; then
			echo -e "${BOLD}${GREEN}" "Custom repo $repo removed from pacman.conf" "$CLR"
		fi
	fi
done

# Change branch to stable in pacman-mirrors.conf
flag=0
for file in $WORKDIR/$PROFILE/$ARCH/{livecd,root,${PROFILE%-*}}-image/etc/pacman-mirrors.conf; do
	if [[ -f $file ]] && [[ ! $QUERY = true ]]; then
		echo "Editing $file"
		sed 's|Branch=testing|Branch=stable|' -i "$file" && flag=1 || exit 1
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

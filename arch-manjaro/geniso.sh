#!/bin/bash
# geniso.sh: generate ISO using buildiso, removing local repo from pacman.conf

# Set defaults
WORKDIR=/opt/buildiso
ARCH=$(uname -m)
QUERY=false
REPOS=()

# Check for root
if [[ $EUID -ne 0 ]]; then
	echo "Must be run as root."
	exit 1
fi

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

# Build the profile chroot
buildiso "$@" -i

# Remove extra repos from pacman.conf
for repo in "${REPOS[@]}"
do
	if ! echo "${VALID[*]}" | grep -q "$repo"; then
		# Remove custom repo
		for file in $WORKDIR/$PROFILE/$ARCH/{livecd,root,${PROFILE%-*}}-image/etc/pacman.conf
		do
			if [[ -f $file ]] && [[ ! $QUERY = true ]]; then
				echo "Editing $file"
				sed -i "/^\[$repo/,/^Server/d" "$file" || exit 1
			fi
		done
		echo "Custom repo $repo removed from pacman.conf"
	fi
done

# Build iso
buildiso "$@" -sc

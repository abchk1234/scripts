#!/bin/bash
# chkaur.sh : utility to check updates from the AUR

# List of packages to check
list=('qbittorrent' 'i-nex' 'yaourt' 'pekwm-menu' 'wallpaperd' 'thermald' 'downgrade')

# Packages which are ignored even if there is change in versions
ignore=('allservers' 'timeset' 'timeset-gui' 'fetter')


case "$1" in

-i)
	# Display ignored packages
	echo -e "\033[1mIgnored: \033[0m"
	for ((i=0;i<${#ignore[@]};i++)); do
		echo ${ignore[$i]}
	done
	;;
*)
	# Check packages in $list for version changes between repo and AUR
	for ((i=0;i<${#list[@]};i++)); do
		in_repo=$(/usr/bin/pacman -Ss ${list[$i]} | head -n 1 | cut -f 2 -d " ")
		in_aur=$(/usr/bin/package-query -A ${list[$i]} | head -n 1 | cut -f 2 -d " ")
		if [ "$in_repo" == "$in_aur" ]; then
			echo "${list[$i]}: no change"
		else
			echo -e "${list[$i]}: \033[1m $in_repo -> $in_aur \033[0m"
		fi
	done
	;;
esac

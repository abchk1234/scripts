#!/bin/bash
# Check no of updates using checkupdates and open forum announcement page

# Variables

browser="xdg-open"
# By default xdg-open command is used to open the link

#browser="firefox"
#browser="midori"
#browser="chromium"

link="https://forum.manjaro.org/index.php?board=39.0"
# Link to the forum announcements page for stable branch

#link="https://forum.manjaro.org/index.php?board=40.0"
# Testing branch
#link="https://forum.manjaro.org/index.php?board=41.0"
# Unstable branch

packages=$(/usr/bin/checkupdates | wc -l)

num=5
# Minimum number package updates to check

allservers="/usr/bin/allservers"
# Path to the allservers script

if [ $packages -gt $num ]; then
	# Open specified link in specified browser
	$browser $link 2> /dev/null
	# Now use allservers.sh to update
	if [ -e $allservers ]; then
		echo "Enter your password to use the allservers script"
		sudo $allservers
	fi
fi

exit 0

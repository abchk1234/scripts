#!/bin/bash
# Script to check internet connection and display notification

# Set count=0
count=0;

# notify function for displaying visual notifiaction
notify () {
	which notify-send 1>/dev/null 2>/dev/null && notify-send "Internet Available"
}

# loop and continuously check internet connection, at a gap of 60s (1 min)
while (true); do
	let count=$count+1
	echo -e "\nCount=$count ($(date +%r)). Checking internet connectivity..."
	sleep 60s;
	ping -c 1 google.com && notify
done

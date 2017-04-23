#!/bin/bash
# to toggle wlan on off

PATH=$PATH:/sbin

turn_wifi_off() {
	# disconnect interface
	ifdown wlan0

	# unload modules for power saving
	modprobe -r brcmfmac
	modprobe -r brcmutil
}

turn_wifi_on() {
	# load modules
	modprobe brcmfmac
	modprobe brcmutil
	
	# connect interface
	ifup wlan0
}

if [ "$EUID" -ne 0 ]; then
	echo "need to run as root"
	exit 1
fi

if [ "$1" = off ]; then
	turn_wifi_off
elif [ "$1" = on ]; then
	turn_wifi_on
fi

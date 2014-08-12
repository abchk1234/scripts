#!/bin/bash
#start_bluetooth.sh
sudo modprobe btusb && sudo systemctl start bluetooth.service || exit 1
blueman-applet &
exit


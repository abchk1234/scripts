#!/bin/bash
# switch-graphics.sh - to switch primary GPU on which desktop runs. Currently supports X11.

# cmd line args

# on hdmi, nvidia needs to be primary gpu to function
# https://stackoverflow.com/questions/47960344/automatically-detect-when-hdmi-is-plugged-in
hdmi_active=$(xrandr |grep ' connected' |grep 'HDMI' |awk '{print $1}')
if [[ ! -z "$hdmi_active" ]]; then
	echo "making nvidia primary"
	sed '/PrimaryGPU/s/#*//g' -i /etc/X11/xorg.conf.d/10-nvidia.conf
else
	echo "making amdgpu primary"
	sed '/PrimaryGPU/s/^/#/g' -i /etc/X11/xorg.conf.d/10-nvidia.conf
fi 

#!/bin/bash
# to act on HDMI cable plug/unplug
# https://bbs.archlinux.org/viewtopic.php?id=170294
# https://superuser.com/questions/485120/how-do-i-align-the-bottom-edges-of-two-monitors-with-xrandr
# https://askubuntu.com/questions/259743/make-xfce-display-manager-use-internal-monitor-after-restart

export DISPLAY=:0.0
 
 INTERNAL_MONITOR_PORT=eDP1
 EXTERNAL_MONITOR_POSITION_HORIZONTAL=left
 EXTERNAL_MONITOR_POSITION_VERTICAL=above
 EXTERNAL_MONITOR_PORT=HDMI1
 
function connect(){
	# xrandr --output HDMI1 --left-of eDP1 --preferred --primary
	# xrandr --output "${EXTERNAL_MONITOR_PORT}" --auto --pos 0x0 --output "${INTERNAL_MONITOR_PORT}" --auto --pos 1920x312
	xrandr --output "${EXTERNAL_MONITOR_PORT}" --auto || exit 1
	xrandr --output "${INTERNAL_MONITOR_PORT}" --off
}
  
function disconnect(){
	xrandr --output "${INTERNAL_MONITOR_PORT}" --auto || exit 1
	xrandr --output "${EXTERNAL_MONITOR_PORT}" --off
}

if xrandr | grep -q "${EXTERNAL_MONITOR_PORT} connected"; then
	sleep 1
	connect
else
	sleep 1
	disconnect
fi

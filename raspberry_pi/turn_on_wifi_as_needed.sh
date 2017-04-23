#!/bin/bash
# to turn on or off wifi based on whether ethernet is connected

PATH=$PATH:/sbin

# Disable wifi if lan is present
if ifconfig eth0 | grep -q 192.168; then
  # eth0 is connected
  if ifconfig | grep -q wlan0; then
    # wlan0 is available
    if ifconfig wlan0 | grep -q 192.168; then
      echo "turning wifi off"
      /bin/bash /usr/local/bin/scripts/toggle_wlan.sh off
    fi
  fi
else
  # eth0 is not connected
  if ! ifconfig wlan0 | grep -q 192.168; then
    echo "turning wifi on"
    /bin/bash /usr/local/bin/scripts/toggle_wlan.sh on
  fi
fi

exit $?

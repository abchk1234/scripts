#!/bin/sh
# check_net: to check if internet connection is working or not

# Counter
min=0

while true; do
       	sleep 60
	let min=$min+1
	echo $min
	ping google.com
	if [ $? -eq 0 ]; then
		notify-send "ping available"
	fi
done

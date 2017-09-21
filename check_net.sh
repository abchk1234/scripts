#!/bin/bash
# check_net: to check if internet connection is working or not

# counter
i=0
# sleep interval (seconds)
int=5

while true; do
        echo $i
        ping -c 1 -W 3 -q google.com > /dev/null
        if [ ! $? -eq 0 ]; then
                notify-send -u low -t 2000 -a "check_net" "ping not available!"
        fi
        echo # line break
        sleep $int
        let i=$i+$int
done

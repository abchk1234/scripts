#!/bin/bash
# https://bbs.archlinux.org/viewtopic.php?pid=1512908#p1512908

#!/bin/bash
POSSIBLE=$(cat /sys/power/state)
if [ $# -gt 0 ]; then
	if [[ $POSSIBLE == *"$1"* ]]; then
		echo $1 > /sys/power/state
	else
		echo "This mode is not supported on this device."
	fi
else
	echo "Usage: state [state]"
	echo "state The state to set the computer to."
	echo "      Possible values:"
	[[ $POSSIBLE == *"freeze"* ]] &&  echo "    0  freeze Suspend to idle (software-based)"
	[[ $POSSIBLE == *"standby"* ]] && echo "    1 standby Stand-by (power-on suspend)"
	[[ $POSSIBLE == *"mem"* ]] &&     echo "    3     mem Suspend to RAM (sleep)"
	[[ $POSSIBLE == *"disk"* ]] &&    echo "    4    disk Suspend to disk (hibernate)"
fi

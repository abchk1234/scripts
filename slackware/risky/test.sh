#!/bin/bash
# test.sh: tests if present OpenRC services start correctly or not.
# Meant to be run in a non-production environment like a VM.

# Run as root
if [ "$EUID" -ne 0 ] ; then
	echo 'Root priviliges required.'
	exit 1
fi

# Colors
BOLD="\e[1m"
CLR="\e[0m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"

# Variables
count_pass=0
count_fail=0
count_na=0

pass=()
fail=()
na=()

# Change to logs directory
cd logs

pass_log=services_passed.log
fail_log=services_failed.log
na_log=services_not_available.log

default_services=( $(rc-update -v | awk -F "|" '{ if ($2 !~ /[a-z]/ ) print $1 "\t" $2 }' | sed 's/ //g') )
ignore_services=(vgl atieventsd nvidia-smi nvidia-persistenced bumblebee xdm-setup consolefont osclock s6-svscan swclock)

# Move existing logs
mv $pass_log ${pass_log}.old
mv $fail_log ${fail_log}.old
mv $na_log ${na_log}.old

# Process services
for service in "${default_services[@]}"; do
	if echo "${ignore_services[*]}" | grep -q "$service"; then
		continue
	fi
	out=$(rc-service "$service" start 2>&1)
	if [ $? -eq 0 ]; then
		let count_pass=$count_pass+1
		pass+=($service)
		echo "$out" >> $pass_log
	else
		if echo "$out" | grep -q -e 'does not exist' -e 'No such file or directory' -e 'command not found'; then
			let count_na=$count_na+1
			na+=($service)
			echo "$out" >> $na_log
		else
			let count_fail=$count_fail+1
			fail+=($service)
			echo "$out" >> $fail_log
		fi
	fi
	echo "$out"
done

echo
echo -e "$BOLD" "Services passed:" "$GREEN" "$count_pass" "$CLR"
echo -e "$BOLD" "Services not available:" "$YELLOW" "$count_na" "$CLR"
echo -e "$BOLD" "Services failed:" "$RED" "$count_fail" "$CLR"

echo
echo -e "$BOLD" "Services failed-" "$CLR"
for svc in "${fail[@]}"; do
	echo "$svc"
done

echo
echo -e "$BOLD" "Services not available-" "$CLR"
for svc in "${na[@]}"; do
	echo "$svc"
done

echo
echo -e "$BOLD" "Services passed-" "$CLR"
for svc in "${pass[@]}"; do
	echo "$svc"
done

echo
echo -e "$BOLD" "Services not checked-" "$CLR"
for svc in "${ignore_services[@]}"; do
	echo "$svc"
done

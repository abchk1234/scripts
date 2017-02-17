#!/bin/bash
# To check open ports via TCP

SITE="$1"
if [ -z "${SITE}" ]; then
	echo "please enter site for which to check"
	exit 1
fi

nmap -sT "${SITE}"

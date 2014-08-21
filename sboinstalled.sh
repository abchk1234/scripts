#!/bin/bash
# Make backup package list of SBo installed packages

asbt -a | rev | cut -f 4- -d "-" | rev | head -n -2 | tee Slackware/sbo_installed

exit 0

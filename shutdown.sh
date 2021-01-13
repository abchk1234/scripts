#!/bin/sh
# shutdown.sh - init agnostic shutdown script

### Checks init system in use, and passes control to it

SHUTDOWN_CMD=shutdown
SHUTDOWN_CMD_ARGS='-h now'
INIT_SYSTEM=init  # sysvinit

SHUTDOWN_ACTIONE=$0  # what we were called as

if [ "$(ps -p 1 -o comm=)" = systemd ]; then
	SHUTDOWN_CMD=systemctl
if [ "$(ps -p 1 -o comm=)" = openrc-init ]; then
	SHUTDOWN_CMD=openrc-shutdown
elif [ "$(ps -p 1 -o comm=)" = runit ]; then
	SHUTDOWN_CMD=runit-init
	SHUTDOWN_CMD_ARGS="0"
fi

if 
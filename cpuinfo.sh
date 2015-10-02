#!/bin/sh
# Get info about cpu drivers being used

echo 'cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver'
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver

echo 'cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

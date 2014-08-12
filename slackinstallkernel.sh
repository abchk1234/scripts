#!/bin/sh
# Script to install built kernel
kernel="$1"
cp arch/x86/boot/bzImage /boot/vmlinuz-custom-$kernel
cp System.map /boot/System.map-custom-$kernel
cp .config /boot/config-custom-$kernel

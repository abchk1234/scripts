#!/bin/bash
# update_grub.sh: to update grub bootloader config

# variables
GENERATE_INITRD=1
KERNEL_VERSION=

# Handle cmd line options
while getopts "gk:h" opt
do
	case "$opt" in
	g) GENERATE_INITRD=0 ;;
	k) KERNEL_VERSION="$OPTARG" ;;
	*) ;;
	esac
done

MKINITRD_PARAMS=
[ "${KERNEL_VERSION}" != '' ] && MKINITRD_PARAMS="-k ${KERNEL_VERSION}"

# regenrate initrd because we usually forget that
[ "${GENERATE_INITRD}" -eq 0 ] && $(/usr/share/mkinitrd/mkinitrd_command_generator.sh $MKINITRD_PARAMS | tail -n 1)

# finally (re)generate grub config
grub-mkconfig -o /boot/grub/grub.cfg

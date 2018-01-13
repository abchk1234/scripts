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
[ "${KERNEL_VERSION}" != '' ] && MKINITRD_PARAMS=(-k ${KERNEL_VERSION} -a \"-o /boot/initrd-${KERNEL_VERSION}.gz -F\")

# regenrate initrd because we usually forget that
if [ "${GENERATE_INITRD}" -eq 0 ]; then
	mkinitrd_cmd="/usr/share/mkinitrd/mkinitrd_command_generator.sh ${MKINITRD_PARAMS[*]} | tail -n 1"
	echo "generating initrd as $mkinitrd_cmd"
	$(eval "${mkinitrd_cmd}")
fi

# finally (re)generate grub config
grub-mkconfig -o /boot/grub/grub.cfg

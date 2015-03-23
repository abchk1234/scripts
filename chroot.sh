#!/bin/bash
# chroot.sh

# Exit if location not specified
if [ -z "$1" ]; then
	echo "chroot folder not specified"
	exit 1
elif [ "$1" = -h ]; then
	echo "./chroot.sh <chroot-folder"
	exit 1
fi

location=$1
cd $location

# Mounting, basic
sudo mount -t proc proc $1/proc/
sudo mount -o bind /sys $1/sys/
sudo mount -o bind /dev $1/dev/

# Mounting extra partition which is already mounted on host
# first one is host mount path, second is chroot mount 
sudo mount -B /mnt/datalinux2 $1/mnt/data

# For internet access
sudo cp /etc/resolv.conf etc/resolv.conf

# Finally, chroot
sudo chroot $location /bin/bash

# Unmounting after exit from chroot
sudo umount $1/mnt/data
sudo umount proc/ sys/ dev/

echo "Done"

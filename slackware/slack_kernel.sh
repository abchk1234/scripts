#!/bin/sh
# Script to get, build and install kernels in Slackware Linux

version="$1"  # Version of the kernel specified as first command line argument
if [ -z "$version" ]; then
	echo "No version specified"
	exit 1
fi

arch=$(uname -a)

# Get base version of kernel, ie, for 3.10.17, base version is 3.10
base_version=$(echo $version | cut -f -2 -d ".")

get () {
	# Check if kernel tarball is present
	# First check for base version present
	if [ ! -e linux-"$base_version".tar.xz ] && [ ! -e linux-"$base_version".tar.gz ] && [ ! -e linux-"$base_version".tar.bz2 ]; then
		# Download the base kernel
		wget -nc http://www.kernel.org/pub/linux/kernel/v3.x/"$base_version".xz
	fi
	# Check patch version, else download it
	if [ ! -e patch-"$version" ] && [ ! -e patch-"$version".xz ] && [ ! -e patch-"$version".gz ] && [ ! -e patch-"$version".bz2 ]; then
		if [ ! "$version" = "$base_version" ]; then
			# Download the patch
			wget -nc http://www.kernel.org/pub/linux/kernel/v3.x/patch-"$version".xz
		fi
	fi
}

extract_release () {
	# Check if kernel directory is available
	if [ -d "linux-$version" ]; then
		return 0
	fi
	# Else extract the base version
	if [ -f linux-"$base_version".xz ] || [ -f linux-"$base_version".tar.gz ] || [ -f linux-"$base_version".tar.bz2 ]; then
		tar xvf linux-"$base_version".?z* || exit 1
	else
		return 1
	fi
}

extract_patch () {
	if [ -d "linux-$base_version" ]; then
		# Need to check if patch for $version is available
		if [ -e "patch-$version".xz ]; then
			# Extract the patch
			unxz patch-$version.?z
		elif [ -f patch-"$version".tar.gz ]; then
			gunzip patch-"$version".tar.gz
		else
			return 1
		fi
	fi
}

apply_patch () {
	# Now check and apply patch
	if [ -e "patch-$version" ]; then
		# Change into the src directory and apply the patch
		cd "linux-$base_version" && patch -p1 < ../"patch-$version" || exit 1
		# Change name of src directory so state can be verified
		cd .. && mv -v "linux-$base_version" "linux-$version"
	fi
}

extract () {
	extract_release
	extract_patch
	apply_patch
}

config() {
	# Copy the config
	if [ -e "../config-*$base_version-*" ]; then
		mv .config .config.old
		cp ../config-*$base_version-* .config
	fi
}

build() {
	if [ -d "linux-$version" ]; then
		# Remove stale .o files and dependencies
		make mrproper
		# Config handling is manual
		make oldconfig
		# Custom config too
		make menuconfig
		# Build the kernel
		make -j3 bzImage
		# Build the modules
		make -j3 modules
	else
		return 1
	fi
}

install() {
	# Install the modules
	sudo make modules_install
	# Copy the built kernel and configs
	sudo cp arch/x86/boot/bzImage /boot/vmlinuz-custom-$version
	sudo cp System.map /boot/System.map-custom-$version
	sudo cp .config /boot/config-custom-$version
}

remove() {
	sudo rm -r /lib/modules/"$version"
	sudo rm /boot/vmlinuz-custom-"$version"
	sudo rm /boot/System.map-custom-"$version"
	sudo rm /boot/config-custom-"$version"
}

post_install() {
	# Update bootloader
	sudo update-grub
}

clean() {
	cd linux-"$version" && patch -R -p1 < ../patch-"$version"
	cd .. && mv -v linux-"$version" linux-"$base_version"
}

#get
#clean
#extract
#config
#build
#install
#post_install
#remove

echo "Done"

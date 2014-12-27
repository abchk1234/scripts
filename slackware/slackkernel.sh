#!/bin/sh
# Script to build and install kernel

version="$1"  # Version of the kernel specified as first command line argument
if [ -z "$version" ]; then
	echo "No version specified" && exit 1
fi
# Get base version of kernel, ie, for 3.10.17, base version is 3.10
base_version=$(echo $version | cut -f -2 -d ".")

get () {
	# Check if kernel tarball is present
	# Check patch version, else download it
	if [ ! -e patch-$version ] && [ ! -e patch-$version ]; then
		# Download the patch
		wget -nc http://www.kernel.org/pub/linux/kernel/v3.x/patch-$version.xz
	fi
}

extract () {
	# Check if kernel directory is available
	if [ -d "linux-$version " ]; then
		# Change to kernel directory
		cd "linux-$version"
	elif [ -d "linux-$base_version" ]; then
		# Need to check if patch for $version is available
		if [ -e "patch-$version.xz" ]; then
			# Extract the patch
			unxz patch-$version.xz
		fi
		# Now check and apply patch
		if [ -e "patch-$version" ]; then
			# First change name of src directory so state can be verified
			mv -v "linux-$base_version" "linux-$version"
			# Change into the src directory and apply the patch
			cd "linux-$version" && patch -p1 < ../"patch-$version"
		fi
	else
		echo "Could not find directory for linux-$version or linux-$base_version" && exit 1
	fi
}

build() {
	# Remove stale .o files and dependencies
	make mrproper
	# Config handling is manual
	make oldconfig
	# Build the kernel
	make -j3 bzImage
	# Build the modules
	make -j3 modules
}

install() {
	# Install the modules
	sudo make modules_install
	# Copy the built kernel and configs
	sudo cp arch/x86/boot/bzImage /boot/vmlinuz-custom-$version
	sudo cp System.map /boot/System.map-custom-$version
	sudo cp .config /boot/config-custom-$version
}

post_install() {
	# Update bootloader
	sudo update-grub
}

clean() {
	patch -R -p1 < ../patch-$version
	cd .. && mv -v linux-$version linux-$base_version
}

#get
extract
build
install
post_install
clean

echo "Done"

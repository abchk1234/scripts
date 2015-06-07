#!/bin/sh
# Script to get, build and install kernels in Slackware Linux

# functions
check_version() {
	if [ -z "$VERSION" ]; then
		echo "No version specified."
		echo "Kernel version can be specified using the -k argument."
		exit 1
	fi
}

init() {
	check_version
	#ARCH=$(uname -a)
	NUMJOBS=3
	# Get base version of kernel, ie, for 3.10.17, base version is 3.10
	BASEVER=${VERSION%.*}
	# Get really base version, like for 3.10.17, it is 3
	BASEBASEVER=${VERSION%%.*}
	# Check for something like 4.0
	[ "$BASEVER" = "$BASEBASEVER" ] && BASEVER=${VERSION%.*.*}
}

get() {
	#check_version
	# get shasums
	# wget -Nc https://www.kernel.org/pub/linux/kernel/v4.x/sha256sums.asc
	# Check if base kernel version present
	#if [ ! -e "linux-$BASEVER.tar.xz" ] && [ ! -e "linux-$BASEVER.tar.gz" ] && [ ! -e "linux-$BASEVER.tar.bz2" ]; then
		# Download the base kernel
		wget -Nc "http://www.kernel.org/pub/linux/kernel/v${BASEBASEVER}.x/linux-$BASEVER.tar.xz"
	#fi
	# Check patch version, else download it
	#if [ ! -e "patch-$VERSION" ] && [ ! -e "patch-$VERSION.xz" ] && [ ! -e "patch-$VERSION.gz" ] && [ ! -e "patch-$VERSION.bz2" ]; then
		if [ ! "$VERSION" = "$BASEVER" ]; then
			# Download the patch
			wget -Nc "http://www.kernel.org/pub/linux/kernel/v${BASEBASEVER}.x/patch-$VERSION.xz"
		fi
	#fi
}

extract_release() {
	# Check if kernel directory is available
	if [ -d "linux-$VERSION" ]; then
		return 0
	fi
	if [ -d "linux-$BASEVER" ]; then
		return 0
	# Else extract the base version
	elif [ -f "linux-${BASEVER}.tar.xz" ]; then # || [ -f "linux-$BASEVER.tar.gz" ] || [ -f "linux-$BASEVER.tar.bz2" ]
		tar xvf "linux-${BASEVER}.tar.xz" || return 1
	else
		echo "Unable to extract linux-${BASEVER}.tar.xz"
		return 1
	fi
}

extract_patch() {
	# Need to check if patch for specified version is available
	if [ -e "patch-$VERSION.xz" ]; then
		# Extract the patch
		unxz "patch-$VERSION.xz"
	elif [ -f "patch-$VERSION.gz" ]; then
		"gunzip patch-$VERSION.gz"
	else
		return 1
	fi
}

apply_patch() {
	# Now check and apply patch
	if [ -e "patch-$VERSION" ]; then
		# Change into the src directory and apply the patch
		cd "linux-$BASEVER" && patch -p1 < ../"patch-$VERSION" || exit 1
		# Change name of src directory so state can be verified
		cd .. && mv -v "linux-$BASEVER" "linux-$VERSION"
	fi
}

extract(){
	#check_version
	extract_release
	extract_patch
	apply_patch
}

config() {
	#check_version
	# Copy the config
	#if [ -e "../config-generic-$BASEVER-*" ]; then
		[ "basename $(pwd)" != "linux-$VERSION" ] && cd "linux-$VERSION"
		#mv .config .config.old
		cp -i ../config-*"$BASEVER"* .config || exit 1
		# Config handling is manual
		make oldconfig
		# Custom config too
		make menuconfig
	#fi
}

build() {
	#check_version
	# change to proper directory
	[ "basename $(pwd)" != "linux-$VERSION" ] && cd "linux-$VERSION"
	#if [ -d "linux-$VERSION" ]; then
		# Build the kernel
		make -j"$NUMJOBS" bzImage
		# Build the modules
		make -j"$NUMJOBS" modules
	#else
	#	return 1
	#fi
}

install() {
	#check_version
	[ "basename $(pwd)" != "linux-$VERSION" ] && cd "linux-$VERSION"
	# Install the modules
	sudo make modules_install || exit 1
	# Copy the built kernel and configs
	sudo cp -v arch/x86/boot/bzImage "/boot/vmlinuz-custom-$VERSION" || exit 1
	sudo cp -v System.map "/boot/System.map-custom-$VERSION" || exit 1
	sudo cp -v .config "/boot/config-custom-$VERSION" || exit 1
}

remove() {
	#check_version
	sudo rm -rv "/lib/modules/$VERSION" || exit 1
	sudo rm -v "/boot/vmlinuz-custom-$VERSION" || exit 1
	sudo rm -v "/boot/System.map-custom-$VERSION" || exit 1
	sudo rm -v "/boot/config-custom-$VERSION" || exit 1
}

post_install() {
	# Update bootloader
	sudo update-grub
}

clean() {
	#check_version
	[ "basename $(pwd)" != "linux-$VERSION" ] && cd "linux-$VERSION"
	patch -R -p1 < ../"patch-$VERSION" || exit 1
	cd .. && mv -v "linux-$VERSION" "linux-$BASEVER"
}

display_help() {
	cat << EOF
Usage: slack_kernel.sh -k <kernel> <option>
Options-
	[get,-g]	[clean,-c]	[extract,-e]
	[config,-m]	[build,-b]	[install,-i]
	[posinstall,-p]	[remove,-r]	[all(-gembip),-a]
	[help,-h]
EOF
}

# process cmd line args
while getopts "gcembiprahk:" opt; do
	case "$opt" in
	g) get;;
	c) clean;;
	e) extract;;
	m) config;;
	b) build;;
	i) install;;
	p) post_install;;
	r) remove;;
	a) get; extract; config; build; install; post_install;;
	h) display_help ;;
	k) VERSION=$OPTARG; init;;
	*) ;;
	esac
done

echo "Done"

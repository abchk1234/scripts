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

change_dir() {
	check_version
	[ ! "$(basename $(pwd))" = "linux-$VERSION" ] && cd "linux-$VERSION"
}

get() {
	check_version
	# Download the base kernel
	wget -Nc "https://www.kernel.org/pub/linux/kernel/v${BASEBASEVER}.x/linux-$BASEVER.tar.xz"
	# Download patch
	if [ ! "$VERSION" = "$BASEVER" ]; then
		wget -Nc "https://www.kernel.org/pub/linux/kernel/v${BASEBASEVER}.x/patch-$VERSION.xz"
	fi
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
	check_version
	extract_release
	extract_patch
	apply_patch
}

config() {
	# change to proper directory
	change_dir
	# copy the config
	cp -i ../config-*"$BASEVER"* .config || exit 1
	# Config handling is manual
	make oldconfig
	# Custom config too
	make menuconfig
}

build() {
	# change to proper directory
	change_dir
	# Build the kernel
	make -j"$NUMJOBS" bzImage
	# Build the modules
	make -j"$NUMJOBS" modules
}

install() {
	check_version
	# change to proper directory
	change_dir
	echo "Installing kernel ${VERSION}"
	# Install the modules
	sudo make modules_install || exit 1
	# Copy the built kernel and configs
	sudo cp -v arch/x86/boot/bzImage "/boot/vmlinuz-custom-$VERSION" || exit 1
	sudo cp -v System.map "/boot/System.map-custom-$VERSION" || exit 1
	sudo cp -v .config "/boot/config-custom-$VERSION" || exit 1
}

remove() {
	check_version
	echo "Removing kernel ${VERSION}"
	sudo rm -rv "/lib/modules/$VERSION" || exit 1
	sudo rm -v "/boot/vmlinuz-custom-$VERSION" || exit 1
	sudo rm -v "/boot/System.map-custom-$VERSION" || exit 1
	sudo rm -v "/boot/config-custom-$VERSION" || exit 1
}

post_install() {
	# Update bootloader
	echo 'Updating grub configurartion'
	sudo update-grub
}

clean() {
	check_version
	# change to proper directory
	change_dir
	# Unpatch and move the directory to linux-basever
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

#echo "Done"

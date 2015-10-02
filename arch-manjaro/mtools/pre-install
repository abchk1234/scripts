# pre-installation tasks

pre_install() {
	# Remove intel-ucode from Packages
	sed '/intel-ucode/ d' -i "${PROFILEDIR}/shared/Packages" || exit 1
	echo "intel-ucode removed from Packages."

	# Adding Xfer command for build pacman.conf
	sed '/#XferCommand = \/usr\/bin\/wget --passive-ftp -c -O %o %u/ a\
XferCommand = /usr/bin/wget -Nc -q --show-progress --passive-ftp -O %o %u' -i "${PROFILEDIR}/${PROFILE}/pacman-default.conf" -i "${PROFILEDIR}/${PROFILE}/pacman-multilib.conf" || exit 1
	echo "pacman.conf modified for build."
}

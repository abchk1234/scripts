#!/bin/bash
# 10-July-2013: Now using pkgCacheClean instead of CacheClean. It uses
# pacman's version checking method.
#
# 11-June-2013: Made Option 1. available (it is useful on the odd occasion).
# Made the display more informative during the progress of each option.
#
# 13-May-2013: Removed the ability for Option 1. to be run standalone, 
# due to having been told to read this:
# https://wiki.archlinux.org/index.php/Pacman#Partial_upgrades_are_unsupported 
#
# 27-April-2013: Updated to use the new pacman-mirrors -g to rankmirrors. :)
#
# allservers.sh - inspired by Manjaro's Carl & Phil, initially hung together 
# by handy, the script's display prettied up & progress information added by Phil, 
# the menu & wiki page added by handy.
# Latest revision now calls everything via the menu.
# The following wiki page is about this script: 
# http://wiki.manjaro.org/index.php/Allservers.sh_Script:-_Rankmirrors,_Synchronise_Pacman_Database
# Following wiki page will introduce pkgCacheClean & related information:
# http://wiki.manjaro.org/index.php/Maintaining_/var/cache/pacman/pkg_for_System_Safety
#___________________________________________________________
# 
# allservers.sh is now completely menu driven. The Menu describes
# what it does for you, if you need more detail see the two
# wiki page links listed above.
###########################################################

err() {
   ALL_OFF="\e[1;0m"
   BOLD="\e[1;1m"
   RED="${BOLD}\e[1;31m"
	local mesg=$1; shift
	printf "${RED}==>${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

msg() {
   ALL_OFF="\e[1;0m"
   BOLD="\e[1;1m"
   GREEN="${BOLD}\e[1;32m"
	local mesg=$1; shift
	printf "${GREEN}==>${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}


if  [ "$EUID" != 0 ]
then
  err "Must use 'sudo su' before you run this script."
  exit 1
fi


# The menu:

clear # Clear the screen.

echo
echo -e "\033[1m                      allservers.sh \033[0m"
echo
echo -e "\e[1;32m    Enter chosen Option's number OR hit Return to exit. "
echo
echo  "    [1] Rank Mirrors & update mirrorlist: pacman-mirrors -g " 
echo  "        & then sync/refresh package lists: pacman -Syy "
echo
echo  "    [2] Option 1. plus Upgrade the System: pacman -Syu "
echo  "        & then run pkgCacheClean: pkgcacheclean "
echo
echo  "    [3] Option 1. plus Upgrade the System & AUR: yaourt -Syua "
echo  "        & then run pkgCacheClean: pkgcacheclean "
echo
echo  "    [4] Upgrade the System only: pacman -Syu "
echo  "        & then run pkgCacheClean: pkgcacheclean "
echo
echo  "    [5] Upgrade the System & AUR only: yaourt - Syua "
echo  "        & then run pkgCacheClean: pkgcacheclean "
echo
echo -ne "\033[1m  Enter Your Choice: \033[0m"

read option

case "$option" in
# Note variable is quoted.

 "1")
 echo
 msg "Processing mirrors:"
 echo
 pacman-mirrors -g
 echo
 msg "Your mirrors have been ranked &"
 msg "the mirrorlist has now been refreshed."
 echo
 msg "Refreshing your pacman database:"
 pacman -Syy
 echo
 msg "Your mirrors & package database are now synchronised."
 echo
 ;;
# Note double semicolon to terminate each option.

 "2")
 echo
 msg "Processing mirrors:"
 echo
 pacman-mirrors -g
 echo
 msg "Your mirrors have been ranked &"
 msg "the mirrorlist has now been refreshed."
 echo
 msg "Refreshing your pacman database:"
 pacman -Syy
 echo
 msg "Your mirrors & package database are now synchronised."
 echo
 msg "Upgrading System:"
 echo
 pacman -Syu
 echo
 msg "System upgrade complete."
 echo
 msg "pkgCacheClean will now remove all but the 2 most "
 msg "recent versions of the installation packages in "
 msg "/var/cache/pacman/pkg directory:"
 echo
 pkgcacheclean
 echo
 msg "pkgCacheClean has done its job. "
 echo
 ;;
# Note double semicolon to terminate each option.

 "3")
 echo
 msg "Processing mirrors:"
 echo
 pacman-mirrors -g
 echo
 msg "Your mirrors have been ranked &"
 msg "the mirrorlist has now been refreshed."
 echo
 msg "Refreshing your pacman database:"
 pacman -Syy
 echo
 msg "Your mirrors & package database are now synchronised."
 echo
 msg "Upgrading System & AUR:"
 echo
 yaourt -Syua
 echo
 msg "System including AUR packages are up to date."
 echo
 msg "pkgCacheClean will now remove all but the 2 most "
 msg "recent versions of the installation packages in "
 msg "/var/cache/pacman/pkg directory:"
 echo
 pkgcacheclean
 echo
 msg "pkgCacheClean has done its job. "
 echo
 ;;
# Note double semicolon to terminate each option.

 "4")
 echo
 msg "Upgrading System:"
 echo
 pacman -Syu
 echo
 msg "System update complete."
 echo
 msg "pkgCacheClean will now remove all but the 2 most "
 msg "recent versions of the installation packages in "
 msg "/var/cache/pacman/pkg directory:"
 echo
 pkgcacheclean
 echo
 msg "pkgCacheClean has done its job. "
 echo
 ;;
# Note double semicolon to terminate each option.

 "5")
 echo
 msg "Upgrading System & AUR: "
 echo
 yaourt -Syua
 echo
 msg "System including AUR packages are up to date. "
 echo
 msg "pkgCacheClean will now remove all but the 2 most "
 msg "recent versions of the installation packages in "
 msg "/var/cache/pacman/pkg directory:"
 echo
 pkgcacheclean
 echo
 msg "pkgCacheClean has done its job. "
 echo
 ;;
# Note double semicolon to terminate each option.

esac

exit 0


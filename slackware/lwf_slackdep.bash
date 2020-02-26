#!/bin/bash
# 2019, lockywolf gmail.com
# ldd's /bin/, /sbin/, /usr/bin/, and /usr/sbin/,
# looking for "not found" and prints the relevant packages.

FILENAMES=$(find {/bin/,/sbin/,/usr/bin/,/usr/sbin/} -executable -type f | sort)
#FILENAMES=$(find /usr/bin/32 -executable -type f)

REPORT=""
PACKAGES=""

for fname in $FILENAMES
do
    # printf "%s" "$fname"
    # temp=$(ldd "$fname" 2>/dev/null | grep "not found")
    temp=$(ldd "$fname" 2>/dev/null)
    # printf "%s\n" "$fname"
    missing_libs=$(printf "%s" "$temp" | grep "not found")
    # printf "%s\n" "$missing_libs"
    if [[ "$missing_libs" != "" ]]; then
	printf "Found a broken binary: %s\n" "$fname"
	printf "Libs=%s\n" "$missing_libs"
	package=$(grep -lr "${fname:1}" "/var/log/packages")
	printf "Package=%s\n" "$package"
	REPORT="$REPORT"$(printf "Broken:%s\n%s\n%s\n\n" "$fname" "$missing_libs" "$package")
	PACKAGES="$PACKAGES"$(printf "\n%s\n" "$package")
    fi
done

# LIBS=$(printf "%s" "$LIBS" | uniq)
#printf "Packages before uniquing:\n"
#printf "%s\n" "$PACKAGES"
PACKAGES=$(printf "%s" "$PACKAGES" | sort |uniq)
#printf "%s" "$REPORT"
printf "%s" "Broken packages after uniquing:\n"
printf "%s" "$PACKAGES"
printf "\n"

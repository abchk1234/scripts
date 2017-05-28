#!/bin/sh
#
# lddd - find broken library links on your machine
#
# http://www.linuxquestions.org/questions/slackware-14/slack-script-to-detect-orphaned-libraries-broken-lib-links-missing-dependencies-794133/page2.html#post3891968

ifs=$IFS
IFS=':'

libdirs="/lib64:/usr/lib64"
extras=

echo " this will take a while..."
#  Check ELF binaries in the PATH and specified dir trees.
for tree in $PATH $libdirs $extras
do
    echo DIR $tree

    #  Get list of files in tree.
    files=$(find $tree -type f ! -name '*.a' ! -name '*.la' ! -name '*.py*' ! -name '*.txt' ! -name '*.h' ! -name '*.ttf' ! -name '*.rb' ! -name '*.ko' ! -name '*.pc' ! -name '*.enc' ! -name '*.cf' ! -name '*.def' ! -name '*.rules' ! -name '*.cmi' ! -name  '*.mli' ! -name '*.ml' ! -name '*.cma' ! -name '*.cmx' ! -name '*.cmxa' ! -name '*.pod' ! -name '*.pm' ! -name '*.pl' ! -name '*.al' ! -name '*.tcl' ! -name '*.bs' ! -name '*.o' ! -name '*.png' ! -name '*.gif' ! -name '*.cmo' ! -name '*.cgi' ! -name '*.defs' ! -name '*.conf' ! -name '*_LOCALE' ! -name 'Compose' ! -name '*_OBJS' ! -name '*.msg' ! -name '*.mcopclass' ! -name '*.mcoptype')
    IFS=$ifs
    for i in $files
    do
        if [ `file $i | grep -c 'ELF'` -ne 0 ]; then
            #  Is an ELF binary.
            if [ `ldd $i 2>/dev/null | grep -c 'not found'` -ne 0 ]; then
                #  Missing lib.
                echo "$i:" >> lddd.txt
                ldd $i 2>/dev/null | grep 'not found' >> lddd.txt
            fi
        fi
    done
done
echo "Files saved to lddd.txt"

# vim:ft=sh:ts=4:sw=4:et:

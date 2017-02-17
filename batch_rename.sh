#!/bin/bash
# rename_batch.sh: to rename a batch of files based on a particular regex
# http://stackoverflow.com/questions/1086502/rename-multiple-files-in-unix

DIR='.'
PATTERN='s/openrc-openrc/openrc/'

for old in ${DIR}/*; do
	new=$(echo "${old}" | sed -e ${PATTERN})
	mv -v "${old}" "${new}"
done

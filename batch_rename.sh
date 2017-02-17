#!/bin/bash
# rename_batch.sh: to rename a batch of files based on a particular regex

DIR='.'
PATTERN='s/openrc-openrc/openrc/'

for old in ${DIR}/*; do
	new=$(echo "${old}" | sed -e ${PATTERN})
	mv -v "${old}" "${new}"
done

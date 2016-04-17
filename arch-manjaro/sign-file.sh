#!/bin/bash
# To sign something with specified gpg key.

GPGKEY=518B147D

gpg --detach-sign --use-agent -u "${GPGKEY}" "$1"

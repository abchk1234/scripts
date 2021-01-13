#!/bin/sh
# Cleanup /tmp however, do not remove sockets for X
# https://docs.slackware.com/howtos:general_admin:free_your_space

# No lost+found with reiserfs
find /tmp/lost+found -exec /bin/touch {} \;
find /tmp -type s -exec /bin/touch {} \;
find /tmp -type d -empty -mtime +7 -exec /bin/rmdir {} \;
find /tmp -type f -mtime +7 -exec rm -rf {} \;

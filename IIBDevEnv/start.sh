#!/bin/bash
set -e

#Start mariadb
service mysql start

# run container in the foreground
tail -f /dev/null

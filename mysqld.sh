#!/bin/sh
### In mysqld.sh (make sure this file is chmod +x):
# `chpst -u mysql` runs the given command as the user `mysql`.
# If you omit that part, the command will be run as root.

exec chpst -u mysql /usr/bin/mysqld_safe  2>&1 

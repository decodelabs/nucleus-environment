#!/bin/bash
set -e
set -u
set -o pipefail

# Pipe mysql 3306 port to Unix socket
rm -f /var/run/mysqld/mysqld.sock
su -c "socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork TCP:mariadb:3306 &" -s /bin/bash nucleus

# Run FPM
exec "$@"

#!/bin/bash
set -e
set -u
set -o pipefail

# Pipe mysql 3306 port to Unix socket
rm -f /var/run/mysqld/mysqld.sock
su -c "socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork TCP:mariadb:3306 &" -s /bin/bash nucleus

# Setup git
su -c "git config --global user.name \"${GIT_NAME}\"" -s /bin/sh nucleus
su -c "git config --global user.email \"${GIT_EMAIL}\"" -s /bin/sh nucleus

# Copy certificates
mkdir -p /srv/env/nucleus/certificates/
cp -R /srv/util/certificates/* /srv/env/nucleus/certificates/

# Run FPM
exec "$@"

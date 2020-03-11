#!/bin/bash
set -e
set -u
set -o pipefail

# Pipe mysql 3306 port to Unix socket
rm -f /var/run/mysqld/mysqld.sock
su -c "socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork TCP:mariadb:3306 &" -s /bin/bash ${USERNAME}
socat TCP-LISTEN:80,fork TCP:nginx:80 &
socat TCP-LISTEN:443,fork TCP:nginx:443 &

# Setup git
su -c "git config --global user.name \"${GIT_NAME}\"" -s /bin/sh ${USERNAME}
su -c "git config --global user.email \"${GIT_EMAIL}\"" -s /bin/sh ${USERNAME}

/usr/sbin/sshd

# Run FPM
exec "$@"

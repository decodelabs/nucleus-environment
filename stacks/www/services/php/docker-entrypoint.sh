#!/bin/bash
set -e
set -u
set -o pipefail

# Pipe mysql 3306 port to Unix socket
rm -f /var/run/mysqld/mysqld.sock
su -c "socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork TCP:mariadb:3306 &" -s /bin/bash ${USERNAME}

# Setup git
su -c "git config --global user.name \"${GIT_NAME}\"" -s /bin/sh ${USERNAME}
su -c "git config --global user.email \"${GIT_EMAIL}\"" -s /bin/sh ${USERNAME}

/usr/sbin/sshd

# Run FPM
exec "$@"

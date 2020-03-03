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

# Certificates
if [[ ! -d /srv/env/nucleus/config/certificates/ ]]; then
    mkdir -p /srv/env/nucleus/config/certificates/
fi

if [[ ! -f /srv/env/nucleus/config/certificates/nucleus.bundle.crt ]]; then
	cd /srv/env/nucleus/config/certificates/
    cp /srv/util/certificates/nucleus.localtest.ext .
	openssl genrsa -des3 -passout pass:nucleus -out nucleus.ca.key 2048
	openssl req -x509 -new -nodes -passin pass:nucleus -key nucleus.ca.key -sha256 -days 1825 -out nucleus.ca.pem -subj "/C=GB/ST=London/L=/O=/OU=/CN=nucleus"
	openssl dhparam -out dhparams.pem 2048
	openssl genrsa -passout pass:nucleus -out nucleus.localtest.key 2048
	openssl req -new -passin pass:nucleus -key nucleus.localtest.key -out nucleus.localtest.csr -subj "/C=GB/ST=London/L=/O=/OU=/CN=nucleus"
	openssl x509 -req -in nucleus.localtest.csr -CA nucleus.ca.pem -CAkey nucleus.ca.key -CAcreateserial -passin pass:nucleus -out nucleus.localtest.crt -days 1825 -sha256 -extfile nucleus.localtest.ext
	cat nucleus.localtest.crt nucleus.ca.pem > nucleus.bundle.crt
fi


if [[ ! -f /home/nucleus/.ssh/known_hosts ]]; then
	ssh-keyscan -H github.com >> /home/nucleus/.ssh/known_hosts
	ssh-keyscan -H bitbucket.org >> /home/nucleus/.ssh/known_hosts
	ssh-keyscan -H codebasehq.com >> /home/nucleus/.ssh/known_hosts
	ssh-keyscan -H gitlab.com >> /home/nucleus/.ssh/known_hosts
	chown nucleus:nucleus /home/nucleus/.ssh/known_hosts
fi

if [[ ! -f /home/nucleus/.ssh/id_rsa && -f /srv/env/nucleus/config/certificates/identity.key ]]; then
	cp /srv/env/nucleus/config/certificates/identity.key /home/nucleus/.ssh/id_rsa
	chown nucleus:nucleus /home/nucleus/.ssh/id_rsa
	chmod 0600 /home/nucleus/.ssh/id_rsa
fi

if [[ -d /home/nucleus/.vscode-server ]]; then
	chown nucleus:nucleus /home/nucleus/.vscode-server/
fi

/usr/sbin/sshd

# Run FPM
exec "$@"

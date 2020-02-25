FROM phpdockerio/php73-fpm:latest

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set user & group
ENV MY_USER="nucleus" \
	MY_GROUP="nucleus" \
	MY_UID="1000" \
	MY_GID="1000"

RUN set -eux \
	&& groupadd -g ${MY_GID} -r ${MY_GROUP} \
	&& useradd -u ${MY_UID} -m -s /bin/bash -g ${MY_GROUP} ${MY_USER} \
	&& echo "PS1='\[\033[01;36m\]\h\[\033[00m\]@\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '" >> /home/nucleus/.profile \
	&& chown nucleus:nucleus /home/nucleus/.profile


# Install selected extensions and other stuff
RUN apt-get update \
	&& curl -sL https://deb.nodesource.com/setup_13.x | bash - \
    && apt-get -y --no-install-recommends install \
		php7.3-bcmath php7.3-gd php7.3-gmp php-imagick php7.3-intl php7.3-ldap php-memcached php7.3-mysql php-redis php-xdebug \
		autoconf automake bash-completion binutils build-essential coreutils dnsutils iputils-ping net-tools netcat socat sudo  \
		bzip2 git git-flow nano rsync supervisor unzip zip \
		imagemagick nodejs openssh-client redis-tools sassc \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
	&& curl -s https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer \
	&& mkdir -p /var/run/mysqld/ \
	&& chown nucleus:nucleus /var/run/mysqld/


# PHPMyAdmin
RUN mkdir /srv/util/ \
	&& cd /srv/util/ \
	&& composer create-project phpmyadmin/phpmyadmin --no-dev \
	&& cd /srv/util/phpmyadmin \
	&& composer update --no-dev \
	&& mkdir /srv/util/phpmyadmin/tmp

COPY ./config/phpmyadmin.config.inc.php /srv/util/phpmyadmin/config.inc.php
RUN chown -R nucleus:nucleus /srv/util/phpmyadmin


# Certificates
RUN cd /srv/util/ \
	&& mkdir /srv/util/certificates/ \
	&& cd /srv/util/certificates/ \
	&& openssl genrsa -des3 -passout pass:nucleus -out nucleus.ca.key 2048 \
	&& openssl req -x509 -new -nodes -passin pass:nucleus -key nucleus.ca.key -sha256 -days 1825 -out nucleus.ca.pem -subj "/C=GB/ST=London/L=/O=/OU=/CN=nucleus" \
	&& openssl dhparam -out dhparams.pem 2048 \
	&& openssl genrsa -passout pass:nucleus -out nucleus.localtest.key 2048 \
	&& openssl req -new -passin pass:nucleus -key nucleus.localtest.key -out nucleus.localtest.csr -subj "/C=GB/ST=London/L=/O=/OU=/CN=nucleus"

COPY ./certificates/nucleus.localtest.ext /srv/util/certificates/nucleus.localtest.ext

RUN cd /srv/util/certificates/ \
	&& openssl x509 -req -in nucleus.localtest.csr -CA nucleus.ca.pem -CAkey nucleus.ca.key -CAcreateserial -passin pass:nucleus -out nucleus.localtest.crt -days 1825 -sha256 -extfile nucleus.localtest.ext \
	&& cat nucleus.localtest.crt nucleus.ca.pem > nucleus.bundle.crt


# Volumes
VOLUME /srv/util/


# Setup entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]


# Run
CMD ["/usr/sbin/php-fpm7.3", "-O" ]

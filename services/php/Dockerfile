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
		imagemagick nodejs openssh-client openssh-server redis-tools sassc \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install composer
RUN curl -s https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer

# Setup dirs
RUN mkdir -p /var/run/mysqld/ \
	&& chown nucleus:nucleus /var/run/mysqld/ \
	&& mkdir -p /srv/util/certificates/ \
	&& chown nucleus:nucleus /srv/util/certificates/ \
	&& mkdir -p /run/sshd \
	&& mkdir -p /home/nucleus/.ssh/ \
	&& chown nucleus:nucleus /home/nucleus/.ssh/


# PHPMyAdmin
COPY ./config/phpmyadmin.config.inc.php /srv/util/phpmyadmin.config.inc.php
RUN cd /srv/util/ \
	&& composer create-project phpmyadmin/phpmyadmin --no-dev \
	&& cd /srv/util/phpmyadmin \
	&& composer update --no-dev \
	&& mkdir /srv/util/phpmyadmin/tmp \
	&& mv /srv/util/phpmyadmin.config.inc.php /srv/util/phpmyadmin/config.inc.php \
	&& chown -R nucleus:nucleus /srv/util/phpmyadmin


# Certificates
COPY ./certificates/nucleus.localtest.ext /srv/util/certificates/nucleus.localtest.ext

# Settings
RUN echo "fs.inotify.max_user_watches=204800" | sudo tee -a /etc/sysctl.conf

# Volumes
VOLUME /srv/util/


# Setup entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]


# Run
CMD ["/usr/sbin/php-fpm7.3", "-O" ]

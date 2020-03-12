FROM phpdockerio/php73-fpm:latest

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set user & group
ARG USERNAME=nucleus
ARG PASSWORD=nucleus
ARG GIT_NAME=nucleus
ARG GIT_EMAIL=nucleus@localtest.me

ENV USERNAME="$USERNAME" \
	PASSWORD="$PASSWORD" \
	GIT_NAME="$GIT_NAME" \
	GIT_EMAIL="$GIT_EMAIL" \
	MY_UID="1000" \
	MY_GID="1000"

RUN set -eux \
	&& groupadd -g ${MY_GID} -r ${USERNAME} \
	&& useradd -u ${MY_UID} -m -s /bin/bash -g ${USERNAME} ${USERNAME} \
	&& mkdir /etc/sudoers.d/ \
	&& echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd \
	&& echo "PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;34m\]\H\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '" >> /home/${USERNAME}/.profile \
	&& echo "export USERNAME=$USERNAME" >> /home/${USERNAME}/.profile \
	&& echo "export PASSWORD=$PASSWORD" >> /home/${USERNAME}/.profile \
	&& echo "export GIT_NAME=$GIT_NAME" >> /home/${USERNAME}/.profile \
	&& echo "export GIT_EMAIL=$GIT_EMAIL" >> /home/${USERNAME}/.profile \
	&& chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.profile


# Install selected extensions and other stuff
RUN apt-get update \
	&& curl -sL https://deb.nodesource.com/setup_13.x | bash - \
    && apt-get -y --no-install-recommends install \
		php7.3-bcmath php7.3-gd php7.3-gmp php-imagick php7.3-intl php7.3-ldap php-memcached php7.3-mysql php-redis php-xdebug \
		autoconf automake bash-completion binutils build-essential coreutils dnsutils iputils-ping locales net-tools netcat socat sudo  \
		bzip2 git git-flow nano rsync supervisor unzip zip \
		imagemagick nodejs openssh-client openssh-server redis-tools sassc \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


# Install composer
RUN curl -s https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer


# Setup dirs
RUN mkdir -p /run/sshd \
	&& mkdir -p /var/run/mysqld/ \
	&& mkdir -p /home/${USERNAME}/.ssh/ \
	&& mkdir -p /home/${USERNAME}/.vscode-server/ \
	&& chown ${USERNAME}:${USERNAME} /var/run/mysqld/ \
	&& chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh/ \
	&& chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.vscode-server/


# PHPMyAdmin
COPY ./config/phpmyadmin.config.inc.php /srv/util/phpmyadmin.config.inc.php
RUN cd /srv/util/ \
	&& composer create-project phpmyadmin/phpmyadmin --no-dev \
	&& cd /srv/util/phpmyadmin \
	&& composer update --no-dev \
	&& mkdir /srv/util/phpmyadmin/tmp \
	&& mv /srv/util/phpmyadmin.config.inc.php /srv/util/phpmyadmin/config.inc.php \
	&& chown -R ${USERNAME}:${USERNAME} /srv/util/phpmyadmin


# Settings
RUN echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf


# Install packages
RUN npm install -g vsce


# Volumes
VOLUME /srv/util/


# Setup locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8


# Setup entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]


# Run
CMD ["/usr/sbin/php-fpm7.3", "-O" ]

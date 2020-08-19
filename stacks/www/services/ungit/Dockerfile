FROM phpdockerio/php73-cli:latest

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
	&& curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get -y --no-install-recommends install \
		nodejs git git-flow ssh \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


# Setup dirs
RUN mkdir -p /home/${USERNAME}/.ssh/ \
	&& chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh/


# Install packages
RUN npm install ungit -g

# Volumes
VOLUME /srv/www

# Port
EXPOSE 8448


# Setup entrypoint
#COPY docker-entrypoint.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/docker-entrypoint.sh
#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

USER tom

# Run
CMD ["ungit", "--no-launchBrowser", "--forcedLaunchPath=/srv/www", "--ungitBindIp=0.0.0.0"]

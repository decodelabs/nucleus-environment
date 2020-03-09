FROM codercom/code-server:latest

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive
USER root

# Update user
RUN set -eux \
	&& echo "PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;34m\]\H\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '" >> /home/coder/.profile \
	&& chown coder:coder /home/coder/.profile

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
		php7.3 \
    bzip2 git git-flow nano rsync unzip zip \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


# Setup entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER coder
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["dumb-init", "code-server", "--host", "0.0.0.0"]

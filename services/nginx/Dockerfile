FROM nginx

# Set user & group
ENV MY_USER="nucleus" \
	MY_GROUP="nucleus" \
	MY_UID="1000" \
	MY_GID="1000"

RUN set -eux \
	&& groupadd -g ${MY_GID} -r ${MY_GROUP} \
	&& useradd -u ${MY_UID} -m -s /bin/bash -g ${MY_GROUP} ${MY_USER}

# Expose ports
EXPOSE 80 443

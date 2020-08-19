#!/bin/bash
set -e
set -u
set -o pipefail

# Setup git
su -c "git config --global user.name \"${GIT_NAME}\"" -s /bin/sh ${USERNAME}
su -c "git config --global user.email \"${GIT_EMAIL}\"" -s /bin/sh ${USERNAME}

# Run Ungit
su -c "$@" -s /bin/sh ${USERNAME}
#exec "$@"

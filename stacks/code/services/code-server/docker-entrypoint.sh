#!/bin/bash
set -e
set -u
set -o pipefail


# Setup git
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"


# Run command
exec "$@"

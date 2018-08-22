#!/bin/bash
#
# Prepares the "stack" to run apps and the environment to run buildpacks
#
set -x
set -e

PYTHON_MAJOR_VERSION=$(python -c 'import platform; print(platform.python_version_tuple()[0])')

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# Debian slim has some issue with some packages that try to install
# manpages into directories that don't exist (e.g postgresql-client).
# So we create those dirs here.
# https://github.com/debuerreotype/debuerreotype/issues/10
# Rumors have it that this will be fixed in the next debian version (buster).
mkdir -p /usr/share/man/man1/
mkdir -p /usr/share/man/man7/


# Update package listings
apt-get update -y

# Update system
apt-get upgrade -y

#
# SYSTEM PACKAGES
#
# Install packages
# xargs apt-get install -y --no-install-recommends < ${BASEDIR}/packages.txt
# The sed command removes comments and empty lines from the packages file.
cat ${BASEDIR}/packages.minimal.txt | sed '/^#/ d' | sed '/^$/d' | xargs apt-get install -y --no-install-recommends
cat ${BASEDIR}/packages.useful-for-django.txt | sed '/^#/ d' | sed '/^$/d' | xargs apt-get install -y --no-install-recommends

pip install -U pip setuptools pipenv virtualenv

#
# pipsi for simple installation of python commands
#
# NOTE: PATH=/root/.local/bin:$PATH must be set in the Dockerfile
python ${BASEDIR}/get-pipsi.py

#
# MISC
#

# tini: minimal PID 1 init. reaps zombie processes and forwards signals.
# set
# ENTRYPOINT ["/tini", "--"]
# in the Dockerfile to make it the default method for starting processes.
# https://github.com/krallin/tini
curl -L --show-error --retry 5 -o /tini https://github.com/krallin/tini/releases/download/v0.18.0/tini
chmod +x /tini

# cleanup
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
apt-get clean

# workaround for a bug in hub.docker.com
ln -s -f /bin/true /usr/bin/chfn

# Add all directories in /app/addons-dev to the PYTHONPATH
cp ${BASEDIR}/add_addons_dev_to_syspath.py ${PYTHON_SITE_PACKAGES_ROOT}/add_addons_dev_to_syspath.py
cp ${BASEDIR}/add_addons_dev_to_syspath.pth ${PYTHON_SITE_PACKAGES_ROOT}/add_addons_dev_to_syspath.pth

# Prepare /app and /data directories
mkdir -p /app && mkdir -p /data

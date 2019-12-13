#!/usr/bin/env sh

set -e

export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
export DEBIAN_FRONTEND=noninteractive

# Get debian release (jessie,stretch,buster,...)
RELEASE=$(cat /etc/os-release | sed -n 's/.*VERSION="[0-9]\+ (\(.*\))"/\1/p')

###############
# Environment #
###############

printf "[\033[36mEnvironment\033[0m] \033[32mSetup...\033[0m\n"

# Notes:
# - set `container` environment variable for environment checks
cat <<EOF > /etc/environment
container="vagrant"
EOF

#########
# Clean #
#########

if dpkg -s exim4 > /dev/null 2>&1 ; then
    printf "[\033[36mExim4\033[0m] \033[32mClean...\033[0m\n"

    # Notes:
    # - `exim4` is pre-installed in jessie/stretch bento debian vagrant images
    apt-get --quiet --yes -o=Dpkg::Use-Pty=0 --purge autoremove \
      exim4 exim4-base exim4-config exim4-daemon-light
fi

#######
# Apt #
#######

printf "[\033[36mApt\033[0m] \033[32mUpdate...\033[0m\n"

apt-get --quiet update
apt-get --quiet --yes -o=Dpkg::Use-Pty=0 --purge --auto-remove dist-upgrade

case ${RELEASE} in
stretch)
  printf "[\033[36mApt\033[0m] \033[32mDependencies...\033[0m\n"

  # Notes:
  # - `dirmngr` is required to handle apt keys
  # - `python-backports.ssl-match-hostname` is required to use `python-docker`
  apt-get --quiet --yes -o=Dpkg::Use-Pty=0 --no-install-recommends --verbose-versions install \
    dirmngr
  ;;
esac

printf "[\033[36mApt\033[0m] \033[32mClean...\033[0m\n"

apt-get clean

###########
# Ansible #
###########

printf "[\033[36mAnsible\033[0m] \033[32mSetup...\033[0m\n"

case ${RELEASE} in
jessie)
  cat <<EOF > /etc/apt/sources.list.d/ppa_launchpad_net_ansible_ansible_ubuntu.list
    deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main
EOF
  ;;
stretch)
  cat <<EOF > /etc/apt/sources.list.d/ppa_launchpad_net_ansible_ansible_ubuntu.list
    deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main
EOF
  ;;
buster)
  cat <<EOF > /etc/apt/sources.list.d/ppa_launchpad_net_ansible_ansible_ubuntu.list
    deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main
EOF
  ;;
esac

apt-key adv --quiet --recv-keys --keyserver keyserver.ubuntu.com 93C4A3FD7BB9C367
apt-get --quiet update

printf "[\033[36mAnsible\033[0m] \033[32mInstall...\033[0m\n"

apt-get --quiet --yes -o=Dpkg::Use-Pty=0 --no-install-recommends --verbose-versions install \
  ansible python3 python3-apt

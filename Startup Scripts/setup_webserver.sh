#!/bin/zsh

set -ex

function install_dependencies() {
  sudo apt-get update
  sudo rm /boot/grub/menu.lst
  sudo update-grub-legacy-ec2 -y
  sudo DEBIAN_FRONTEND=noninteractive apt-get update -yqq \
  && sudo sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yqq \
  && sudo apt-get install -yqq --no-install-recommends \
  		apt-utils \
		  bzip2 \
		  curl \
		  freetds-dev \
		  git \
		  jq \
		  libcurl4-openssl-dev \
		  libffi-dev \
		  libkrb5-dev \
		  liblapack-dev \
		  libpq-dev \
		  libpq5 \
		  libsasl2-dev \
		  libssl-dev \
		  libxml2-dev \
		  libxslt-dev \
		  postgresql-client \
		  python \
	  	python3 \
		  python3-dev \
		  python3-pip \
      build-essential \
      freetds-bin \
      locales \
      netcat \
      rsync \
    && sudo sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

function install_python_and_python_packages() {
  pip3 install -qU setuptools wheel --ignore-installed

  PYCURL_SSL_LIBRARY=openssl pip3 install \
    --no-cache-dir --compile --ignore-installed \
    pycurl


}
}
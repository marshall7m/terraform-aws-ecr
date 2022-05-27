#!/bin/bash

apt-get -y update

apt-get install -y \
    software-properties-common build-essential \
    apt-transport-https ca-certificates gnupg lsb-release curl sudo

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

chmod u+x /usr/bin/*
chmod u+x /usr/local/bin/*
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
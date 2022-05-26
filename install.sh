#!/bin/bash

apt-get -y update
apt-get install -y aptitude
aptitude install -y \
    software-properties-common build-essential \
    libffi-dev gcc libpq-dev \
    wget curl sudo unzip git \
    python3-dev python3-pip python3-venv python3-wheel python3 \
    awscli
    

python3 -m venv $VIRTUAL_ENV
source $VIRTUAL_ENV/bin/activate
python3 -m pip install --upgrade pip --upgrade  -r requirements.txt

wget -q -O /tmp/tfenv.tar.gz https://github.com/tfutils/tfenv/archive/refs/tags/v${TFENV_VERSION}.tar.gz
tar -zxf /tmp/tfenv.tar.gz -C /tmp
mkdir /usr/local/.tfenv && mv /tmp/tfenv-${TFENV_VERSION}/* /usr/local/.tfenv && chmod u+x /usr/local/.tfenv/bin/tfenv
export PATH="$VIRTUAL_ENV/bin:$VIRTUAL_ENV/lib/python3.9/site-packages:/usr/local/.tfenv/bin:$PATH"


chmod u+x /usr/local/bin/*
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
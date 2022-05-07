#!/bin/bash

DOCKER_REPO_URL="https://download.docker.com/linux/centos/docker-ce.repo"

PYTHON_ROOT_URL="https://www.python.org/ftp/python"
PYTHON_VERSION="3.10.4"
PYTHON_PKG_NAME="Python-$PYTHON_VERSION"
PYTHON_PKG_FILE="$PYTHON_PKG_NAME.tgz"
PYTHON_PKG_URL="$PYTHON_ROOT_URL/$PYTHON_VERSION/$PYTHON_PKG_FILE"

system-update () {
    sudo yum update -y
    sudo yum install wget -y
}

install-docker () {
    sudo yum remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo "$DOCKER_REPO_URL"
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl enable docker
}

install-python () {
    sudo yum install gcc openssl-devel bzip2-devel libffi-devel -y
    cd ~
    wget "$PYTHON_PKG_URL"
    tar -xzf "$PYTHON_PKG_FILE"
    cd "$PYTHON_PKG_NAME"/
    sudo ./configure --with-ssl
    sudo make && sudo make install
    sudo ln -s /usr/local/python3 /usr/bin/python3
    sudo ln -s /usr/local/pip3 /usr/bin/pip3
}

main () {
    system-update
    install-docker
    install-python
}

main "$@"
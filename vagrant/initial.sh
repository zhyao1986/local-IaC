#!/bin/bash
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
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl enable docker
}

install-python () {
    sudo yum install gcc openssl-devel bzip2-devel libffi-devel -y
    cd ~
    wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
    tar -xzf Python-3.10.4.tgz
    cd Python-3.10.4/
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
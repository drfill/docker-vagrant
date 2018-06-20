FROM phusion/baseimage:master
MAINTAINER Fill Q <admin@njoyx.net>

# Environment variables
ENV HOME /home/vagrant
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Do common baseimage actions
RUN adduser --disabled-password --gecos "" vagrant && \
    echo "/home/vagrant" > /etc/container_environment/HOME && \
    echo "noninteractive" > /etc/container_environment/DEBIAN_FRONTEND && \
    echo "linux" > /etc/container_environment/TERM && \
    rm -f /etc/service/sshd/down && \
    /usr/sbin/enable_insecure_key && \
    /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install necessary packages
RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends \
        sudo \
        git \
        vim \
        nano \
        curl \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chmod -x /etc/my_init.d/10_syslog-ng.init

# Add Vagrant key
RUN echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/00-vagrant && \
    mkdir -p /home/vagrant/.ssh && \
    curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys

# Cleanups
RUN rm -rf /tmp/* /var/tmp/*

# Init process is entrypoint
ENTRYPOINT ["/sbin/my_init", "--"]

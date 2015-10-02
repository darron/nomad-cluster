#!/bin/bash
apt-get clean
apt-get update
apt-get -y upgrade
apt-get install -y curl

# Docker
curl -sSL https://get.docker.com/ | sh

# Nomad
curl -s https://packagecloud.io/install/repositories/darron/nomad/script.deb.sh | sudo bash
apt-get install -y nomad

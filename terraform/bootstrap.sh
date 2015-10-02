#!/bin/bash
sudo service nomad stop
IP_ADDRESS=$(ifconfig eth0 | grep "inet addr" | cut --delimiter=":" -f 2 | cut --delimiter=" " -f 1)
cat > /tmp/server.hcl <<EOF
log_level = "DEBUG"
bind_addr = "$IP_ADDRESS"
data_dir = "/var/lib/nomad"
server {
  enabled = true
  bootstrap_expect = 3
}
EOF
sudo mv -f /tmp/server.hcl /etc/nomad.d/server.hcl
sudo rm -rf /var/lib/nomad/*
sudo service nomad start
export NOMAD_ADDR="http://$IP_ADDRESS:4646"

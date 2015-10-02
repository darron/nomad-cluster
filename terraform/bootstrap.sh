#!/bin/bash
sudo service nomad stop
IP_ADDRESS=$(ifconfig eth0 | grep "inet addr" | cut --delimiter=":" -f 2 | cut --delimiter=" " -f 1)
cat > /tmp/server.hcl <<EOF
log_level = "DEBUG"
bind_addr = "$IP_ADDRESS"
advertise {
  rpc = "$IP_ADDRESS:4647"
  serf = "$IP_ADDRESS:4648"
}
data_dir = "/var/lib/nomad"
server {
  enabled = true
  bootstrap_expect = 3
}
EOF
cat > /tmp/nomad.default <<EOF
OPTIONS=""
LOGFILE="/var/log/nomad/nomad.log"
NOMAD_ADDR="http://$IP_ADDRESS:4646"
EOF
sudo mv -f /tmp/server.hcl /etc/nomad.d/server.hcl
sudo mv -f /tmp/nomad.default /etc/default/nomad
sudo rm -rf /var/lib/nomad/*
sudo service nomad start

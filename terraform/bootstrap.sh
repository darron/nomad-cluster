#!/bin/bash
sudo service nomad stop
IP_ADDRESS=$(ifconfig eth0 | grep "inet addr" | cut --delimiter=":" -f 2 | cut --delimiter=" " -f 1)
cat > /tmp/server.hcl <<EOF
log_level = "DEBUG"
enable_debug = true
bind_addr = "0.0.0.0"
advertise {
  http = "$IP_ADDRESS:4646"
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
cat > /tmp/nomad.init <<EOF
description "Nomad - A Distributed, Highly Available, Datacenter-Aware Scheduler"

emits nomad-up

start on runlevel [2345]
stop on runlevel [!2345]

script
  if [ -f /etc/default/nomad ]; then
    . /etc/default/nomad
  fi
  export NOMAD_ADDR="http://$IP_ADDRESS:4646"
  exec /usr/local/bin/nomad agent -config /etc/nomad.d >> /var/log/nomad/nomad.log
end script

post-start exec initctl emit nomad-up

kill signal INT
EOF
sudo mv -f /tmp/server.hcl /etc/nomad.d/server.hcl
sudo mv -f /tmp/nomad.default /etc/default/nomad
sudo mv -f /tmp/nomad.init /etc/init/nomad.conf
sudo rm -rf /var/lib/nomad/*
sudo service nomad start

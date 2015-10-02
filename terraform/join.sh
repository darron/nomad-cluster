#!/bin/bash
IP_ADDRESS=$(ifconfig eth0 | grep "inet addr" | cut --delimiter=":" -f 2 | cut --delimiter=" " -f 1)
NOMAD_SERVER=$(cat /tmp/nomad-server-addr)
nomad server-join -address=http://$IP_ADDRESS:4646 $NOMAD_SERVER

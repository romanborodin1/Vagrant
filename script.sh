#!/bin/bash
# Delete default route in Vagrant VM-box like: "default via 10.0.2.2 dev eth0 proto dhcp metric 100"

sudo -i
eval `ip route show default  | awk '{ if ($5 =="eth0" && $2 != "0.0.0.0") print "ip route del default dev " $5; }'`

ip route add default via 172.24.113.1 dev eth2 metric 50

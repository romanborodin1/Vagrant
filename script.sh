#!/usr/bin/bash

yum update -y

# Delete default route in Vagrant VM-box like: "default via 10.0.2.2 dev eth0 proto dhcp metric 100"
eval `ip route show default  | awk '{ if ($5 =="eth0" && $2 != "0.0.0.0") print "ip route del default dev " $5; }'`

# Create static IP address for the interface eth1
IP_ADDR1="192.168.88.11"
ETH1_CFG="/etc/sysconfig/network-scripts/ifcfg-eth1"

echo "BOOTPROTO=none" > $ETH1_CFG
echo "ONBOOT=yes" >> $ETH1_CFG
echo "DEVICE=eth1" >> $ETH1_CFG
echo "NM_CONTROLLED=yes" >> $ETH1_CFG
echo "IPADDR=$IP_ADDR1" >> $ETH1_CFG

systemctl restart network

# Create user and add the SSH pub key
NEW_USER=roman
useradd -G wheel -s /bin/bash -m $NEW_USER

mkdir /home/$NEW_USER/.ssh
touch /home/$NEW_USER/.ssh/authorized_keys
chmod =600 /home/$NEW_USER/.ssh/authorized_keys
chown $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh/authorized_keys

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEiKWPFQl3ERa8bw8MifDkqLIlVWqShfw9lFcRRSvnEsxDhxzVNTu2QXwWz48N5SsFsVAaIrA96RBXr2ehWBzEeXswEzwmsTtRmxlQXp6jDWex2p10xilwqV/MOUZ4XSMZ/+LkRM9L4QQ+FF3uD9NqvyP5Fnu+8debWEHTbcxQc5SjsZiTFdOkjCxoXh+jBe2p9mz1e15vRlsZ/sWa7Z/iCT09nk6ugKkF2ezjWvpc4mFBs14QGCf6d3wAR2eqpidiKH6ZsL3FdWebgE6qePcOgM2PpNc5/HTpQ9Qy0WeQZbuRJ+YjrvS/iFYRaSLN02zSDgwU+9XDbNC0J0PdZbZK6XdB/h4Eoifl7iV2uieFipVPyVWs/R0EwWXp7+enC/hW8mcyGR8fMXJv3JtwHVzdeyYjG3m2fvLz9+UsJLSTa7dzSjWLI1OfyAb1ASBt0JubiR5KEIIQknFuNvss2ELVnd0ejHHjaHTH2HTb/I/Yiw6SPQedf2EURidEznY4n4c= roman@leader" >> /home/$NEW_USER/.ssh/authorized_keys

systemctl reload sshd

exit


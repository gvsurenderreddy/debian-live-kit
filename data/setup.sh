#!/bin/bash
# setup the base system

echo "adding user live"
pass=$(perl -e 'print crypt($ARGV[0], "password")' live)
useradd -m -p $pass live
[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"

echo "setting password for root"
echo -e "root\nroot" | passwd

new=$(sed s/"RELEASE main"/"RELEASE main contrib non-free"/ < /etc/apt/sources.list) &&  echo $new > /etc/apt/sources.list
groupadd netdev
usermod -a -G netdev live
apt-get update

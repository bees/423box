#!/bin/bash

perl -p -i -e 's#http://us.archive.ubuntu.com/ubuntu#http://mirror.rackspace.com/ubuntu#gi' /etc/apt/sources.list

# Update the box
apt-get -y update >/dev/null
apt-get -y install facter linux-headers-$(uname -r) build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev curl unzip >/dev/null
apt-get install -y linux-headers-3.19.0-25-generic linux-image-3.19.0-25-generic

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Remove 5s grub timeout to speed up booting
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=en_US"
EOF

update-grub

cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_TIMEOUT="1>2"
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=en_US"
EOF

update-grub

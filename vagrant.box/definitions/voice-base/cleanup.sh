set -ex

KVER=$(uname -r | sed 's/[-a-z]*$//')
dpkg -l | grep '\-3.13.0' | grep -v $KVER | awk '{print $2}' | xargs apt-get -y purge
apt-get -y purge linux-headers-$KVER-generic linux-image-$KVER-generic linux-image-extra-$KVER-generic linux-headers-generic linux-image-generic linux-headers-server linux-generic linux-server
apt-get -y autoremove
apt-get clean

rm -rf /tmp/*
rm -f /var/lib/dhcp/*

rm -f /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

echo 'pre-up sleep 2' >> /etc/network/interfaces

rm -f /home/vagrant/*.sh
rm -f /home/vagrant/*.gz
rm -f /home/vagrant/*.iso

dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY
dd if=/dev/zero of=/boot/EMPTY bs=1M || true
rm -f /boot/EMPTY
sync

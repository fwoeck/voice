set -ex

apt-get -y install --no-install-recommends libdbus-1-3

set +e
/etc/init.d/virtualbox-guest-utils stop
/etc/init.d/virtualbox-guest-x11 stop
rmmod vboxguest
set -e
apt-get -y purge virtualbox-guest-x11 virtualbox-guest-dkms virtualbox-guest-utils
apt-get -y install dkms

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop $VBOX_ISO /mnt
set +e
yes | sh /mnt/VBoxLinuxAdditions.run
set -e
umount /mnt

/etc/init.d/vboxadd start
lsmod | grep -q vboxguest

rm $VBOX_ISO

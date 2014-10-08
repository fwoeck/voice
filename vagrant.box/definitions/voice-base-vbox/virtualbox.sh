set -ex

# Without libdbus virtualbox would not start automatically after compile
apt-get -y install --no-install-recommends libdbus-1-3

# The netboot installs the VirtualBox support (old) so we have to remove it
set +e
/etc/init.d/virtualbox-guest-utils stop
/etc/init.d/virtualbox-guest-x11 stop
rmmod vboxguest
set -e
apt-get -y purge virtualbox-guest-x11 virtualbox-guest-dkms virtualbox-guest-utils
apt-get -y install dkms

# Install the VirtualBox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop $VBOX_ISO /mnt
set +e
# It's normal for this to fail because it's unable to install the X drivers.
# By that time the kernel modules have already been installed.
yes | sh /mnt/VBoxLinuxAdditions.run
set -e
umount /mnt

# Check whether the guest additions are installed correctly
/etc/init.d/vboxadd start
lsmod | grep -q vboxguest

# Cleanup VirtualBox
rm $VBOX_ISO

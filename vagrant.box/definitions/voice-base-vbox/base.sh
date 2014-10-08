set -ex

apt-get -y update
apt-get -y dist-upgrade
apt-get -y install aptitude ssh build-essential dkms ssh-askpass git
apt-get -y install linux-lowlatency linux-headers-lowlatency linux-image-lowlatency
apt-get -y install --no-install-recommends xubuntu-desktop firefox xfce4-terminal xubuntu-icon-theme

( cat <<'EOP'
%vagrant ALL=NOPASSWD:ALL
EOP
) > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/

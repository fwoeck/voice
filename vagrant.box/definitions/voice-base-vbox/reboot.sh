set -ex

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT.\+$/GRUB_CMDLINE_LINUX_DEFAULT="text"/' /etc/default/grub
update-grub

shutdown -r now

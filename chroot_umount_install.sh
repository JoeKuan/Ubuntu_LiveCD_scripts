export HOME=/root
export LC_ALL=C

chroot chroot rm -f /var/lib/dbus/machine-id
chroot chroot rm -f /sbin/initctl
chroot chroot dpkg-divert --rename --remove /sbin/initctl
chroot chroot apt-get clean
chroot chroot rm -rf /tmp/*
chroot chroot rm /etc/resolv.conf
chroot chroot umount -lf /proc
chroot chroot umount -lf /sys
chroot chroot umount -lf /dev/pts
umount `pwd`/chroot/dev

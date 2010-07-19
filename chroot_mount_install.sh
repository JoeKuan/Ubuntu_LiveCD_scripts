mount --bind /dev chroot/dev
cp /etc/hosts chroot/etc/hosts
cp /etc/resolv.conf chroot/etc/resolv.conf
cp /etc/apt/sources.list chroot/etc/apt/sources.list
chroot chroot mount -t proc none /proc
chroot chroot mount -t sysfs none /sys
chroot chroot mount -t devpts none /dev/pts


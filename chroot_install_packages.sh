export HOME=/root
export LC_ALL=C

echo ">>>> Installing DBus .... "
apt-get install --yes dbus
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
# For 9.10 issue
ln -s /bin/true /sbin/initctl
touch /tmp/initctl_divert
echo ">>>> Done"
echo

echo ">>>> Installing grub and network manager ... "
apt-get install --yes grub2 plymouth-x11
apt-get install --yes --no-install-recommends network-manager
echo "Done"
echo

echo ">>>> Installing LiveCD installer ... "
apt-get install --yes ubiquity-frontend-gtk
echo "Done"
echo

echo ">>>> Installing packages for LiveCD .... "
apt-get install --yes ubuntu-minimal casper lupin-casper 
apt-get install --yes discover1 laptop-detect os-prober 
apt-get install --yes linux-generic 
echo "Done"
echo


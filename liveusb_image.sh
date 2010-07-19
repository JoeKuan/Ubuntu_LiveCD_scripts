USB_IMG_SIZE=600M
echo ">>>> Preparing LiveUSB image .... "
mkdir liveusb liveusb/mnt 2> /dev/null
cd liveusb
touch loop
dd if=/dev/zero of=loop bs=1 count=1 seek=$USB_IMG_SIZE
mkdosfs -F 16 -n rescue loop
mkdir tmp 2> /dev/null
mount -o loop ../ubuntu-remix.iso tmp
mount -o loop loop mnt
echo ">>>> Done"
echo

echo ">>>> Copying LiveUSB files .... "
cp -a tmp/* mnt/
cd mnt
mv isolinux/* .
rmdir isolinux/
mv isolinux.bin syslinux.bin
mv isolinux.cfg syslinux.cfg
cd ..
umount mnt
umount tmp
syslinux loop
echo ">>>> Done"
echo

echo ">>>> Compressing LiveUSB image .... "
gzip -c loop > ../remixusb.gz
echo ">>>> Done"
echo


echo ">>>> Preparing LiveCD image .... "
mkdir -p image/casper 2> /dev/null
mkdir -p image/isolinux 2> /dev/null
mkdir -p image/install 2> /dev/null
cp chroot/boot/vmlinuz-2.6.**-**-* image/casper/vmlinuz
cp chroot/boot/initrd.img-2.6.**-**-* image/casper/initrd.gz
cp /usr/lib/syslinux/isolinux.bin image/isolinux/
cp /boot/memtest86+.bin image/install/memtest
cp /boot/sbm.img image/install/
echo ">>>> Done\n"

echo ">>>> Copying Boot-loader and Splash files .... "
cp isolinux.cfg isolinux.txt image/isolinux
cp README.diskdefines image/
echo ">>>> Done\n"

echo ">>>> Create manifest .... "
chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee image/casper/filesystem.manifest
cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
REMOVE='ubiquity casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
for i in $REMOVE 
do
        sudo sed -i "/${i}/d" image/casper/filesystem.manifest-desktop
done
echo ">>>> Done\n"

echo ">>>> Compress chroot .... "
rm -f image/casper/filesystem.squashfs
mksquashfs chroot image/casper/filesystem.squashfs 
printf $(sudo du -sx --block-size=1 chroot | cut -f1) > image/casper/filesystem.size
#echo ">>>> Done\n"

#echo ">>>> Recognition as an Ubuntu Remix"
#touch image/ubuntu
#mkdir image/.disk 2> /dev/null
#cd image/.disk
#touch base_installable
#echo "full_cd/single" > cd_type
#echo 'Ubuntu 10.04' > info
##echo "http//ubuntu-rescue-remix.org" > release_notes_url
#cd ../..
#echo ">>>> Done\n"

echo ">>>> Calculating MD5 .... "
(cd image && find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt)
echo ">>>> Done\n"

IMAGE_NAME="Ubuntu_LiveCD"
echo ">>>> Create ISO image .... "
cd image
mkisofs -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../ubuntu-remix.iso .
cd ..
echo ">>>> Done\n"

rm -f remixusb.gz

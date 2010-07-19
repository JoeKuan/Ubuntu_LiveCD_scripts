if [ -z "$RELEASE_NAME" ] || [ -z "$ARCH" ]
then
  echo "Error: RELEASE_NAME or ARCH is not defined"
  exit 1
fi

if [ -d "chroot.$RELEASE_NAME.debootstrap" ]
then
  echo "Bootstrap directory already exist. Remove"
  rm -fr chroot.$RELEASE_NAME.debootstrap
fi

sudo apt-get install debootstrap
sudo debootstrap --arch=$ARCH $RELEASE_NAME chroot.$RELEASE_NAME.debootstrap
if [ $BACKUP_BOOTSTRAP -eq 1 ]
then
  echo "Copying chroot.$RELEASE_NAME.debootstrap to chroot"
  cp -fr chroot.$RELEASE_NAME.debootstrap chroot
fi

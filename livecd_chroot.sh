DIST_UPDATE_SCRIPT=chroot_update_distrib.sh
INST_PKG_SCRIPT=chroot_install_packages.sh

# These are the steps defined for certain operations
# Add or modify for your own need
ALL="chroot_debootstrap chroot_mount_install chroot_dist_update chroot_inst_pkgs chroot_umount_install make_all_images"
UPDATE="chroot_mount_install chroot_dist_update chroot_umount_install make_all_images"
INSTALL="chroot_mount_install chroot_dist_update chroot_inst_pkgs chroot_umount_install make_all_images"

run_chroot_script() {
  cp $1 chroot/tmp/
  chroot chroot sh /tmp/$1
  rm chroot/tmp/$1
}

chroot_dist_update() { run_chroot_script $DIST_UPDATE_SCRIPT; }
chroot_inst_pkgs() { run_chroot_script $INST_PKG_SCRIPT; }

make_all_images() {
  sh livecd_image.sh
  sh liveusb_image.sh
}

chroot_debootstrap() {
  if [ -d "chroot" ]
  then
    echo "Error: chroot directory already exists. Please MANUALY remove or rename the directory first"
    echo "Or do 'sh $0 clean' to start a new bootstrap"
    exit 2
  fi
  if [ ! -f "./livecd_chroot.conf" ]
  then
    echo "Error: livecd_chroot.conf configuration file not found"
    exit 3
  fi

  . ./livecd_chroot.conf
  echo $RELEASE_NAME $ARCH
  if [ -z "$RELEASE_NAME" ] || [ -z "$ARCH" ]
  then
    echo "Error: RELEASE_NAME or ARCH is not defined."
    exit 1
  fi

  . ./chroot_debootstrap.sh
}

chroot_mount_install() {
  if [ ! -d "chroot" ]
  then
    echo "Error: Expect chroot directory"
    exit 1
  fi

  if [ -f "chroot/tmp/_mount_install" ]
  then
    echo "Mount install has run already. Ignored"
  else
    echo "Mount all the necessary directories"
    touch chroot/tmp/_mount_install
    sh chroot_mount_install.sh
  fi
}

chroot_umount_install() {
  if [ -f "chroot/tmp/_mount_install" ]
  then
    sh chroot_umount_install.sh
    rm chroot/tmp/_mount_install
  fi
}

chroot_clean() {
  chroot_umount_install
  rm -fr chroot image liveusb remixusb.gz ubuntu-remix.iso
}

# If no arg, just default to dist upgrade
case $1 in
	"all" ) STEPS=$ALL ;;
	"install" ) STEPS=$INSTALL ;;
	"-h" | "--help" ) echo "Usage: $0 [ all | install | update (default) | clean | bootstrap ]" ;;
	"clean" ) chroot_clean ;;
	"bootstrap" ) chroot_debootstrap ;;
	"update" | * ) STEPS=$UPDATE ;;
esac

#echo "STEPS = $STEPS."
for i in $STEPS
do
  echo "Running $i"
  $i
done

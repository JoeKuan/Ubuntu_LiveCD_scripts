if [ $# != 1 ]
then
  echo "$0 <usb device>"
  exit 1
fi

zcat remixusb.gz | sudo tee $1 >/dev/null

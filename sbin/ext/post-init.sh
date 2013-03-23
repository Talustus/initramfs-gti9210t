#!/sbin/busybox sh
#

# Remount FileSys RW
/sbin/busybox mount -t rootfs -o remount,rw rootfs

## Create the kernel data directory
if [ ! -d /data/.dream ];
then
  mkdir /data/.dream
  chmod 777 /data/.dream
fi

## Enable "post-init" ...
if [ -f /data/.dream/post-init.log ];
then
  # BackUp old post-init log
  mv /data/.dream/post-init.log /data/.dream/post-init.log.BAK
fi

# Start logging
date >/data/.dream/post-init.log
exec >>/data/.dream/post-init.log 2>&1

# Check Kernel profiles
echo "Checking Extweaks Profiles"
ccxmlsum=`md5sum /res/customconfig/customconfig.xml | awk '{print $1}'`
if [ "a${ccxmlsum}" != "a`cat /data/.dream/.ccxmlsum`" ];
then
  echo "Updating Custom Config profiles"
  rm -f /data/.dream/*.profile
  echo ${ccxmlsum} > /data/.dream/.ccxmlsum
else
  echo "Custom Config up-to-date"
fi

[ ! -f /data/.dream/default.profile ] && cp /res/customconfig/default.profile /data/.dream/
[ ! -f /data/.dream/battery.profile ] && cp /res/customconfig/battery.profile /data/.dream/
[ ! -f /data/.dream/performance.profile ] && cp /res/customconfig/performance.profile /data/.dream/

# Source needed functions for customconfig
. /res/customconfig/customconfig-helper
read_defaults
read_config

## install Kernel related things
# /sbin/busybox sh /sbin/ext/install.sh

## Make uci.sh executable and apply ExTweaks Settings
chmod 0755 /res/uci.sh
/res/uci.sh apply

##### init scripts ########
#(
#/sbin/busybox sh /sbin/ext/run-init-scripts.sh
#)&

# Remount FileSys RO
/sbin/busybox mount -t rootfs -o remount,ro rootfs

echo "Post-init finished ..."

#!/sbin/busybox sh
# DreamKernel v1.x installer
# Script original written by gokhanmoral
# rewritten to fit our needs by Talustus
cd /

# Remount FileSys RW
/sbin/busybox mount -t rootfs -o remount,rw rootfs
/sbin/busybox mount -t ext4 -o remount,rw /system

if [ -s /system/xbin/su ];
then
  echo "Superuser already exists"
else
  # just to make sure ...
  rm -f /system/bin/su
  rm -f /system/xbin/su
  mkdir /system/xbin
  chmod 755 /system/xbin
  xzcat /res/misc/payload/su.xz > /system/xbin/su
  chown 0.0 /system/xbin/su
  chmod 6755 /system/xbin/su

  rm -f /system/app/*uper?ser.apk
  rm -f /system/app/?uper?u.apk
  rm -f /system/app/*chainfire?supersu*.apk
  rm -f /data/app/*uper?ser.apk
  rm -f /data/app/?uper?u.apk
  rm -f /data/app/*chainfire?supersu*.apk
  rm -rf /data/dalvik-cache/*uper?ser.apk*
  rm -rf /data/dalvik-cache/*chainfire?supersu*.apk*
  xzcat /res/misc/payload/Superuser.apk.xz > /system/app/Superuser.apk
  chown 0.0 /system/app/Superuser.apk
  chmod 644 /system/app/Superuser.apk
fi;

echo "Checking if cwmanager is installed"
if [ ! -f /system/.dream/cwmmanager3-installed ];
then
  rm /system/app/CWMManager.apk
  rm /data/dalvik-cache/*CWMManager.apk*
  rm /data/app/eu.chainfire.cfroot.cwmmanager*.apk
  xzcat /res/misc/payload/CWMManager.apk.xz > /system/app/CWMManager.apk
  chown 0.0 /system/app/CWMManager.apk
  chmod 644 /system/app/CWMManager.apk
  mkdir /system/.dream
  chmod 755 /system/.dream
  echo 1 > /system/.dream/cwmmanager3-installed
fi;

# rm -rf /res/misc/payload

# Remount FileSys RO
/sbin/busybox mount -t ext4 -o remount,ro /system
/sbin/busybox mount -t rootfs -o remount,ro rootfs

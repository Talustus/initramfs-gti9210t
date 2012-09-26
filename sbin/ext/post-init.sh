#!/sbin/busybox sh
#
## Create the kernel data directory
mkdir /data/.dream
chmod 777 /data/.dream

## Enable "post-init" ...
mv /data/.dream/post-init.log /data/.dream/post-init.log.bak
busybox date >/data/.dream/post-init.log
exec >>/data/.dream/post-init.log 2>&1

ccxmlsum=`md5sum /res/customconfig/customconfig.xml | awk '{print $1}'`
if [ "a${ccxmlsum}" != "a`cat /data/.dream/.ccxmlsum`" ];
then
  rm -f /data/.dream/*.profile
  echo ${ccxmlsum} > /data/.dream/.ccxmlsum
fi

[ ! -f /data/.dream/default.profile ] && cp /res/customconfig/default.profile /data/.dream
[ ! -f /data/.dream/battery.profile ] && cp /res/customconfig/battery.profile /data/.dream
[ ! -f /data/.dream/performance.profile ] && cp /res/customconfig/performance.profile /data/.dream

. /res/customconfig/customconfig-helper
read_defaults
read_config

# Set Custom Kernel properties
/sbin/busybox sh /sbin/ext/properties.sh

# install Kernel related Apps etc
/sbin/busybox sh /sbin/ext/install.sh

# fix Permissions for some sysfs files

# Chown / Chmod CPU control files
# chown root system /sys/devices/system/cpu/cpu0/
# chown root system /sys/devices/system/cpu/cpu1/
# chmod 0755 /sys/devices/system/cpu/cpu0/
chmod 0755 /sys/devices/system/cpu/cpu1/

# apply ExTweaks Settings
chmod 0755 /res/uci.sh
/res/uci.sh apply

##### init scripts ########
(
/sbin/busybox sh /sbin/ext/run-init-scripts.sh
)&


#!/sbin/busybox sh
#
## Create the kernel data directory
mkdir /data/.dream
chmod 777 /data/.dream

## Enable "post-init" ...
mv /data/.dream/post-init.log /data/.dream/post-init.log.bak
busybox date >/data/.dream/post-init.log
exec >>/data/.dream/post-init.log 2>&1

# Set Custom Kernel properties
/sbin/busybox sh /sbin/ext/properties.sh

# install Kernel related Apps etc
/sbin/busybox sh /sbin/ext/install.sh

##### init scripts ########
(
/sbin/busybox sh /sbin/ext/run-init-scripts.sh
)&

busybox date >>/data/.dream/post-init.log
echo "Post-Init finished"

#!/sbin/sh
#
busybox date > /boot-log.txt
echo "POSTINIT Success" >> /boot-log.txt


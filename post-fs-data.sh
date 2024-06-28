#!/system/bin/sh
# (C) Feravolt 2022
# (C) fastbooteraselk 2024
# Based on Brutal Busybox script.

MODDIR=${0%/*}

 if [ ! -d $MODDIR/system/xbin ]; then
 chown 0:0 $MODDIR/system/bin/busybox;
 chmod 775 $MODDIR/system/bin/busybox;
 chcon u:object_r:system_file:s0 $MODDIR/system/bin/busybox;
 $MODDIR/system/bin/busybox --install -s $MODDIR/system/bin/;
 for sd in /system/bin/*; do
   rm -f $MODDIR/${sd};
 done;
else
 chown 0:0 $MODDIR/system/xbin/busybox;
 chmod 775 $MODDIR/system/xbin/busybox;
 chcon u:object_r:system_file:s0 $MODDIR/system/xbin/busybox;
 $MODDIR/system/xbin/busybox --install -s $MODDIR/system/xbin/;
 fi;
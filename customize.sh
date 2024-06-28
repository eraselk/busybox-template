#!/system/bin/sh
# (C) Feravolt 2022
# (C) fastbooteraselk 2024
# Based on Brutal Busybox Installer Script

# is installing in recovery mode?
$BOOTMODE || abort "Please install in Magisk App!"

# Exit on error
#set -e

BPATH="$MODPATH/system/xbin"

deploy(){
# Init
chmod 755 $BPATH/*

# Detect Architecture

# 64 Bit
if [ "$ARCH" = "arm64" ]; then
mv -f $BPATH/busybox-arm64 $BPATH/busybox
rm -f $BPATH/busybox-arm
ui_print "- $ARCH arch detected."
fi

# 32 Bit
if [ "$ARCH" = "arm" ]; then
mv -f $BPATH/busybox-arm $BPATH/busybox
rm -f $BPATH/busybox-arm64
ui_print "- $ARCH arch detected."
fi

# Not Supported for x86 and x64 ARCH
if [ "$ARCH" = "x86" ]; then
rm -rf $MODPATH
abort "- $ARCH arch not supported."
fi

if [ "$ARCH" = "x64" ]; then
rm -rf $MODPATH
abort "- $ARCH arch not supported."
fi

}

# Check for another busybox
if ! [ -d "/data/adb/modules/eraselk_busybox" ]; then
if [ -e /system/xbin/busybox ]; then
rm -rf $MODPATH
abort "- Please uninstall another busybox from /system/xbin/ and reboot."
fi
if [ -e /system/bin/busybox ]; then
rm -rf $MODPATH
abort "- Please uninstall another busybox from /system/bin/ and reboot."
fi
if [ -e /vendor/bin/busybox ]; then
rm -rf $MODPATH
abort "- Please uninstall another busybox from /vendor/bin/ and reboot."
fi
fi

# Extract Binary
deploy

# Install into /system/bin, if exists.
if [ ! -e /system/xbin ]; then
mkdir -p $MODPATH/system/bin
mv -f $BPATH/busybox $MODPATH/system/bin/busybox
rm -Rf $BPATH
ui_print "- Installing into /system/bin.."
fi

# Print Success
ui_print "- eraselk Busybox installed successfully."
ui_print "- Please reboot right now."

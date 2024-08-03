#!/system/bin/sh
# (C) Feravolt 2022
# (C) fastbooteraselk 2024
# Based on Brutal Busybox Installer Script

# is installing in recovery mode?
$BOOTMODE || abort "Please install in Magisk App!"

# Define external variables
BPATH="$TMPDIR/system/xbin"
a="$MODPATH/system/xbin"
MODVER="$(grep_prop version ${TMPDIR}/module.prop)"

deploy() {

	unzip -qo "$ZIPFILE" 'system/*' -d $TMPDIR

	# Init
	set_perm "$BPATH/busybox*" 0 0 777

	# Detect Architecture

	case "$ARCH" in
	"arm64")
		mv -f $BPATH/busybox-arm64 $a/busybox
		ui_print "- $ARCH arch detected."
		;;

	"arm")
		mv -f $BPATH/busybox-arm $a/busybox
		ui_print "- $ARCH arch detected."
		;;

	"x86")
	        rm -rf $MODPATH
	        rm -rf $NVBASE/modules/$MODID
            abort "! $ARCH arch is not supported"
		;;

	"x64")
        rm -rf $MODPATH
        rm -rf $NVBASE/modules/$MODID
        abort "! $ARCH arch is not supported"
		;;
	esac
}

ui_print "- Module Version $MODVER"

if ! [ -d "$NVBASE/modules/$MODID" ]; then
    find $NVBASE/modules -maxdepth 1 -type d | while read -r another_bb; do
        wleowleo="$(echo "$another_bb" | grep -i 'busybox')"
        if [ -n "$wleowleo" ] && [ -f "$wleowleo/module.prop" ]; then
            touch $wleowleo/remove
        fi
    done            
fi

if [ -d "/data/adb/modules/${MODID}" ] && [ -f "/data/adb/modules/${MODID}/installed" ]; then
	rm -f /data/adb/modules/${MODID}/installed
fi

# Extract Binary
deploy

# Print Busybox Version
BB_VER="$($a/busybox | head -n1 | cut -f1 -d'(')"
ui_print "- $BB_VER"

# Install into /system/bin, if exists.
if [ ! -e /system/xbin ]; then
	mkdir -p $MODPATH/system/bin
	mv -f $a/busybox $MODPATH/system/bin/busybox
	rm -Rf $a
	ui_print "- Installing into /system/bin.."
fi

# Print Success
ui_print "- ${MODNAME} installed successfully."
ui_print "- Please reboot right now."

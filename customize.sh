#!/system/bin/sh
# (C) Feravolt 2022
# (C) fastbooteraselk 2024
# Based on Brutal Busybox Installer Script
$BOOTMODE || exit 1

# Define external variables
BB_TEMP="$TMPDIR/system/xbin"
BB_INSTALL_DIR="$MODPATH/system/xbin"

deploy() {

	unzip -qo "$ZIPFILE" 'system/*' -d $TMPDIR

	set_perm "$BB_TEMP/busybox*" 0 0 777

	# Detect Architecture

	case "$ARCH" in
	"arm64")
		mv -f $BB_TEMP/busybox-arm64 $BB_INSTALL_DIR/busybox
		ui_print "- $ARCH arch detected."
		;;

	"arm")
		mv -f $BB_TEMP/busybox-arm $BB_INSTALL_DIR/busybox
		ui_print "- $ARCH arch detected."
		;;

	*)
            abort "! $ARCH arch is not supported"
	    ;;
	esac
}

if ! [ -d "$NVBASE/modules/$MODID" ]; then
    find $NVBASE/modules -maxdepth 1 -type d | while read -r another_bb; do
        wleowleo="$(echo "$another_bb" | grep -i 'busybox')"
        if [ -n "$wleowleo" ] && [ -f "$wleowleo/module.prop" ] && find $wleowleo -type f -name busybox &>/dev/null; then
	    for i in $wleowleo; do
            touch $i/remove
	    done
        fi
    done            
fi

if [ -d "/data/adb/modules/${MODID}" ] && [ -f "/data/adb/modules/${MODID}/installed" ]; then
	rm -f /data/adb/modules/${MODID}/installed
fi

# Extract Binary
deploy

# Print Busybox Version
BB_VER="$($BB_INSTALL_DIR/busybox | head -n1 | cut -f1 -d'(')"
ui_print "- $BB_VER"

if ! [ -d /system/xbin ]; then
	mkdir -p $MODPATH/system/bin
	mv -f $BB_INSTALL_DIR/busybox $MODPATH/system/bin
	rm -Rf $BB_INSTALL_DIR
	ui_print "- Installing into /system/bin.."
fi

ui_print "- $MODNAME installed successfully."
ui_print "- Please reboot right now."

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

	unzip -o "$ZIPFILE" 'system/*' -d $TMPDIR

	# Init
	chmod 755 $BPATH/*

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
		mv -f $BPATH/busybox-x86 $a/busybox
		ui_print "- $ARCH arch detected"
		;;

	"x64")
		mv -f $BPATH/busybox-x64 $a/busybox
		ui_print "- $ARCH arch detected"
		;;
	esac
}

ui_print "- Module Version $MODVER"

# Check for another busybox
if [ -d "/data/adb/modules/eraselk_busybox" ]; then
	ui_print "- eraselk Busybox detected."
	ui_print "- Reboot and reinstall this module."
	touch /data/adb/modules/eraselk_busybox/remove
	rm -rf $MODPATH
	exit 1
fi

if ! [ -d "/data/adb/modules/${MODID}" ]; then
	find /data/adb/modules -type f -name busybox | while read -r abb; do
		if [ $(echo "$abb" | wc -l) -gt 1 ]; then
			for i in ${abb[@]}; do
				if $i | head -n1 | grep -i 'busybox' >/dev/null 2>&1; then
					abort "- another busybox installed, please uninstall it first."
				fi
			done
		fi
		if $abb | head -n1 | grep -i 'busybox' >/dev/null 2>&1; then
			abort "- another busybox installed, please uninstall it first."
		fi
	done
fi

if [ -d "/data/adb/modules/${MODID}" ] && [ -f "/data/adb/modules/${MODID}/installed" ]; then
	rm -f /data/adb/modules/${MODID}/installed
fi

# Extract Binary
deploy

# Print Busybox Version
BB_VER=$($BPATH/busybox | head -n1 | cut -f1 -d'(')
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

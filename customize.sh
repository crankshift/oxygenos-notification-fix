#!/system/bin/sh

SKIPUNZIP=1

ui_print "======================================="
ui_print " OxygenOS 16 Notification Fix"
ui_print " by crankshift"
ui_print "======================================="
ui_print ""

if [ "$KSU" = true ]; then
  ui_print "- Root method: KernelSU (v${KSU_VER_CODE})"
elif [ "$APATCH" = true ]; then
  ui_print "- Root method: APatch"
else
  ui_print "- Root method: Magisk (v${MAGISK_VER_CODE})"
fi

ui_print "- Android API: $API"
ui_print ""

# Copy module files
unzip -o "$ZIPFILE" module.prop service.sh uninstall.sh -d "$MODPATH" >&2

ui_print "- Changes will take effect after reboot"
ui_print ""
ui_print "======================================="
ui_print " Installation complete!"
ui_print "======================================="

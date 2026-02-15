#!/system/bin/sh

MODDIR=${0%/*}

# Wait for boot to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done

sleep 10

# Disable aggressive OOS16 battery optimization that delays notifications
settings put global device_idle_constants inactive_to=0,light_after_inactive_to=0
cmd power set-adaptive-power-savings-enabled false
settings put global adaptive_battery_management_enabled 0
settings put system ai_preload_user_state 0

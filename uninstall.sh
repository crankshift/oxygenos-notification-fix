#!/system/bin/sh

# Revert to stock OOS16 defaults
settings delete global device_idle_constants
cmd power set-adaptive-power-savings-enabled true
settings put global adaptive_battery_management_enabled 1
settings put system ai_preload_user_state 1

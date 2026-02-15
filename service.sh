#!/system/bin/sh

MODDIR=${0%/*}

# Wait for boot to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done

# Extra delay to ensure system services are ready
sleep 10

# TODO: Add notification fix logic here

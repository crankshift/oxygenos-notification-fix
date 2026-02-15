# OxygenOS 16 Notification Fix

KernelSU / Magisk / APatch module that fixes notification delay issues on OxygenOS 16.

Tested on **OnePlus 15** (Android 16, OxygenOS 16). Should work on other OxygenOS 16 devices.

## What it does

Fixes delayed notifications on OxygenOS 16 by disabling aggressive battery/background optimization that prevents timely notification delivery.

Changes applied at boot and fully reverted on module removal.

## Installation

1. Download the latest `.zip` from [Releases](../../releases)
2. Open **KernelSU Manager** / **Magisk Manager** / **APatch**
3. Go to Modules → Install from storage
4. Select the downloaded zip
5. Reboot

## Uninstallation

Remove the module from your root manager and reboot. All changes will be reverted automatically.

## Compatibility

| Root Method | Supported |
|-------------|-----------|
| KernelSU | Yes |
| Magisk (v20.4+) | Yes |
| APatch | Yes |

## Verified Devices

| Device | OS | Status |
|--------|----|--------|
| OnePlus 15 | OxygenOS 16 (Android 16) | Pending |

> If you tested on another device, please open an issue with your results.

## Building from source

```bash
git clone https://github.com/user/oos16-notification-fix.git
cd oos16-notification-fix
./build.sh
```

Output: `build/oos16-notification-fix-v<version>.zip`

## License

[CC BY-NC-SA 4.0](LICENSE) - Non-commercial use only.

Copyright (c) 2026 crankshift

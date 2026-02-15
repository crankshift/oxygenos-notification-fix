# OxygenOS 16 Notification Fix - KernelSU/Magisk Module

## Project Overview

This is a KernelSU (KSU) and Magisk compatible module that fixes notification issues on OxygenOS 16.

**Target device:** OnePlus 15 (Android 16, OxygenOS 16)
**Compatibility:** Generic OxygenOS 16 devices

## Project Info

- **License:** CC BY-NC-SA 4.0 (no commercial use)
- **Author:** crankshift
- **Repo:** GitHub (public)

## Module Structure

```
.
├── META-INF/
│   └── com/google/android/
│       ├── update-binary            # Magisk installer (KSU ignores this)
│       └── updater-script           # Dummy (#MAGISK)
├── module.prop                      # Module metadata (REQUIRED)
├── customize.sh                     # Install logic (KSU vs Magisk)
├── service.sh                       # Post-boot script
├── uninstall.sh                     # Reverts changes on removal
├── build.sh                         # Build script (creates zip in build/)
├── release.sh                       # Version bump + build + tag
├── CHANGELOG.md                     # Semver changelog (MUST update every release)
├── LICENSE                          # CC BY-NC-SA 4.0
├── README.md
├── CLAUDE.md
└── .gitignore
```

## What the Module Does

Fixes delayed notifications on OOS16. The root cause is aggressive battery/background optimization.
`service.sh` disables these after boot:

- `device_idle_constants` — zeroes doze idle timeouts
- `set-adaptive-power-savings-enabled false` — disables adaptive power savings
- `adaptive_battery_management_enabled 0` — disables adaptive battery
- `ai_preload_user_state 0` — disables OPlus AI preload

`uninstall.sh` reverts all four to stock defaults.

## Key Concepts

### Dual Compatibility (KSU + Magisk + APatch)

- **Magisk** uses `.replace` files inside overlay dirs to remove system apps
- **KernelSU** uses `REMOVE` variable in `customize.sh`
- **APatch** also supports `REMOVE` variable (same as KSU)
- Detect environment: `$KSU` is `true` on KernelSU, `$APATCH` is `true` on APatch

### Shell Scripts

- Use `#!/system/bin/sh` shebang (NOT `#!/bin/bash`)
- Both KSU and Magisk provide BusyBox ash shell — keep scripts POSIX-compatible
- Use `ui_print` for user-facing output during installation
- Available env vars in `customize.sh`: `$MODPATH`, `$TMPDIR`, `$ZIPFILE`, `$ARCH`, `$API`, `$KSU`

## Release Process (MUST follow for every release)

1. **Update `CHANGELOG.md`** — add a new `## [x.y.z] - YYYY-MM-DD` section with all changes
2. Run `./release.sh <patch|minor|major>` — bumps version, builds, commits, tags
3. **Push**: `git push origin main --tags`
4. GitHub Actions will auto-create the release with the zip attached

Semver rules:
- **PATCH** (1.0.x): bug fixes, minor script tweaks
- **MINOR** (1.x.0): new fixes added, new features
- **MAJOR** (x.0.0): breaking changes, major restructure

## Building & Testing

- Build: `./build.sh` (outputs to `build/` directory)
- Install: push zip to device, install via KSU/Magisk Manager
- Verify after reboot: check module is active in root manager

## Development Guidelines

- Do NOT modify `/system` directly — use the systemless overlay
- `service.sh` runs post-boot for runtime fixes
- `uninstall.sh` must revert ALL changes when the module is removed
- Every release MUST include a CHANGELOG.md entry
- No Co-Authored-By lines in git commits

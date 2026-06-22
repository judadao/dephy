# dephy

Board-platform module for Dephy product repositories.

## Overview

`dephy` provides reusable board profiles and Zephyr workspace setup. Product
repos pin this module and select a profile such as `boards/esp32` instead of
duplicating board bootstrap logic.

## Key Value

- Reusable board setup for multiple products.
- Validated Zephyr module lists before product builds.
- Consistent local and CI board profile commands.
- Clear separation between board setup and product logic.

## How To Use

```sh
boards/esp32/scripts/test_profile.sh
boards/esp32/scripts/sync_zephyr_modules.sh --check
boards/esp32/scripts/sync_zephyr_modules.sh
```

Product repos should pin a `dephy-vX.Y.Z` tag and reference a profile path such
as `deps/dephy/boards/esp32`.

## Simple Principle

Product code owns application behavior. `dephy` owns board profile setup and
Zephyr workspace assumptions. The ignored local workspace lives at
`zephyrproject/`.

## Docs

- `docs/module_structure.md`: board/profile structure.
- `docs/todo.md`: current TODO summary.

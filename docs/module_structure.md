# dephy Board Platform Structure

`dephy` provides board-platform profiles for product repositories. It is a
reusable module dependency, but its structure is board-profile oriented instead
of a C library.

## Layout

- `repo.json`: identifies this repo as the `board_platform` module.
- `boards/esp32/deps.json`: Zephyr workspace, board target, and module list for
  the ESP32 profile.
- `boards/esp32/scripts/sync_zephyr_modules.sh`: profile sync entry point.
- `boards/esp32/scripts/test_profile.sh`: local metadata smoke test.
- `boards/esp32/zephyr/`: Zephyr module metadata exported by the profile.
- `docs/todo.yaml`: source of truth for this repo's TODO state.

## Version Policy

Use `dephy-vX.Y.Z` tags for board-platform releases. Product `deps.json` files
should pin a tag and reference the profile path through `module_path`, for
example `deps/dephy/boards/esp32`.

## Sync Behavior

The sync script supports `--check` for no-network validation. Normal sync avoids
redundant work when the module list signature is unchanged and existing module
checkouts are present. Set `DEPHY_FORCE_WEST_UPDATE=1` to refresh modules.

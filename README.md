# dephy

Board-platform module for Dephy product repositories.

`dephy` is the place where board setup is made repeatable. Product repos should
not each invent their own Zephyr workspace bootstrap, board module list, or
board profile layout. They pin this repo, select a profile such as
`boards/esp32`, and let the product stay focused on application behavior.

## Overview

Use this repo when a product needs a known-good board profile and Zephyr module
setup. The README covers the practical usage path; deeper structure notes live
in `docs/` only after the normal flow is clear.

## Key Value

- One board profile can be reused by many products.
- Zephyr module setup is validated before a product build starts.
- Local development and CI use the same profile scripts.
- Board-specific choices stay out of reusable protocol and IO modules.

## How To Use

1. A product pins `dephy` in `deps.json`.
2. The product sync script materializes it under `deps/dephy`.
3. The product build points at a profile path such as
   `deps/dephy/boards/esp32`.
4. The profile validates board metadata, Zephyr module lists, and workspace
   assumptions.
5. Product code includes reusable modules through Zephyr, while board setup
   remains owned here.

## How It Works

The ESP32 profile has two responsibilities:

- `sync_zephyr_modules.sh` checks or syncs the local Zephyr workspace module
  list. It uses a module signature cache, so repeated runs skip redundant work
  unless `DEPHY_FORCE_WEST_UPDATE=1` is set.
- `test_profile.sh` validates the profile without needing to build a full
  product. This catches missing module metadata and broken profile layout early.

The local Zephyr workspace lives at `zephyrproject/` and is intentionally not
committed.

## Layout

```text
boards/esp32/          ESP32 board profile consumed by products
boards/esp32/scripts/  profile validation and Zephyr module sync
boards/esp32/zephyr/   Zephyr module metadata for the profile
docs/                  structure docs and TODO state
repo.json              repository type metadata
```

## Commands

```sh
boards/esp32/scripts/test_profile.sh
boards/esp32/scripts/sync_zephyr_modules.sh --check
boards/esp32/scripts/sync_zephyr_modules.sh
```

Use `--check` in CI or during quick audits. Run the full sync when creating or
refreshing the local Zephyr workspace.

## Versioning

Use `dephy-vX.Y.Z` tags. Product repos should pin a tag and reference profile
paths through `module_path`, for example `deps/dephy/boards/esp32`.

## TODO

TODO state is tracked in `docs/todo.yaml` and summarized in `docs/todo.md`.

# Repository Guidelines

## Project Structure & Module Organization

`dephy` owns board-scoped Zephyr workspace setup and board module profiles.
Board profiles live under `boards/`, currently `boards/esp32/`. Each profile
owns its `deps.json`, profile scripts, and Zephyr module metadata under
`zephyr/`. The local Zephyr workspace lives under `zephyrproject/` and is not
committed.

## Commands

- `boards/esp32/scripts/test_profile.sh` validates ESP32 profile metadata
  without downloading Zephyr modules.
- `boards/esp32/scripts/sync_zephyr_modules.sh --check` prints the resolved
  workspace, board, and module list.
- `boards/esp32/scripts/sync_zephyr_modules.sh` initializes or updates the local
  Zephyr workspace when needed.

## Boundaries

Board setup belongs here. Reusable protocol, broker, IO, and product workflow
logic belongs in module or product repos. Product repos should consume this repo
through `deps.json` and use a board profile path such as `boards/esp32`.

## TODO Workflow

Use `docs/todo.yaml` as the source of truth and keep `docs/todo.md` generated
from it. Update TODO status before and after behavior changes.

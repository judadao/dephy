# dephy

Board-platform module for Dephy product repositories.

`dephy` owns board-scoped Zephyr workspace setup. Product repositories consume a
profile such as `boards/esp32` through `deps.json`; reusable protocol, broker,
IO, and product workflow code belongs in other repos.

## Current Shape

```text
dephy/
├── boards/esp32/
│   ├── deps.json
│   ├── scripts/
│   │   ├── sync_zephyr_modules.sh
│   │   └── test_profile.sh
│   └── zephyr/
│       ├── CMakeLists.txt
│       ├── Kconfig
│       └── module.yml
├── docs/
│   ├── module_structure.md
│   ├── todo.md
│   └── todo.yaml
└── repo.json
```

The local Zephyr workspace lives at `zephyrproject/` and is ignored by git.

## Commands

```sh
boards/esp32/scripts/test_profile.sh
boards/esp32/scripts/sync_zephyr_modules.sh --check
boards/esp32/scripts/sync_zephyr_modules.sh
```

`--check` validates the profile and prints workspace, board, module list, and
signature without initializing a Zephyr workspace. Normal sync uses a module
signature cache and skips redundant work unless `DEPHY_FORCE_WEST_UPDATE=1` is
set.

## Versioning

Use `dephy-vX.Y.Z` tags. Product repos should pin a tag and reference profile
paths through `module_path`, for example `deps/dephy/boards/esp32`.

## TODO

TODO state is tracked in `docs/todo.yaml` and summarized in `docs/todo.md`.

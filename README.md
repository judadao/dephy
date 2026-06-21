# dephy

Board-scoped Zephyr support modules for local product repositories.

This repository keeps Zephyr dependency selection small and reproducible by
splitting board support under `boards/<board>/`. The local Zephyr workspace is
managed inside this repository at `zephyrproject/`, but it is ignored by git.

## Layout

```text
dephy/
├── zephyrproject/        # ignored local Zephyr workspace
└── boards/
    └── esp32/
        ├── deps.json
        ├── scripts/
        │   └── sync_zephyr_modules.sh
        └── zephyr/
            ├── CMakeLists.txt
            ├── Kconfig
            └── module.yml
```

## Usage

Update only the Zephyr modules declared for ESP32:

```bash
./boards/esp32/scripts/sync_zephyr_modules.sh
```

Current initial release tag:

```text
dephy-v0.1.0
```

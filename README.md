# dephy

Board-scoped Zephyr support modules for local product repositories.

This repository keeps Zephyr dependency selection small and reproducible by
splitting board support under `boards/<board>/`. It does not vendor Zephyr
itself. The Zephyr workspace lives next to this repository at `../zephyrproject`.

## Layout

```text
dephy/
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

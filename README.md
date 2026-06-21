# esp32_zephyer

ESP32 Zephyr support module for local product repositories.

This repository keeps the ESP32-specific Zephyr dependency selection small and
reproducible. It does not vendor Zephyr itself. The Zephyr workspace lives next
to this repository at `../zephyrproject`, and `deps.json` lists the Zephyr
modules that should be downloaded for ESP32 work.

## Layout

```text
esp32_zephyer/
├── deps.json
├── scripts/
│   └── sync_zephyr_modules.sh
└── zephyr/
    ├── CMakeLists.txt
    ├── Kconfig
    └── module.yml
```

## Usage

Update only the Zephyr modules declared in `deps.json`:

```bash
./scripts/sync_zephyr_modules.sh
```

Current initial release tag:

```text
esp32-zephyer-v0.1.0
```

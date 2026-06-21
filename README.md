# dephy

Board-scoped Zephyr workspace and module profiles for product repositories.

`dephy` has two separate concepts:

- **Dephy board profile**: a stable directory under `boards/`, such as
  `boards/esp32`. Product `deps.json` files use this for `module_path` and for
  running Dephy helper scripts.
- **Zephyr board target**: the target passed to `west build`, such as
  `esp32_devkitc/esp32/procpu`. This can change with Zephyr releases without
  changing the Dephy profile directory name.

The local Zephyr workspace is created at `zephyrproject/` inside the checked-out
`dephy` repo. It is ignored by git, so a product that clones Dephy into
`deps/dephy` should create/use `deps/dephy/zephyrproject`.

## Layout

```text
dephy/
├── zephyrproject/        # ignored local Zephyr workspace
└── boards/
    └── esp32/
        ├── deps.json     # Zephyr modules and default Zephyr board target
        ├── scripts/
        │   └── sync_zephyr_modules.sh
        └── zephyr/
            ├── CMakeLists.txt
            ├── Kconfig
            └── module.yml
```

## Usage

Update the Zephyr workspace and only the Zephyr modules declared for ESP32:

```bash
./boards/esp32/scripts/sync_zephyr_modules.sh
```

The ESP32 profile currently defaults to this Zephyr target:

```text
esp32_devkitc/esp32/procpu
```

Current release tag:

```text
dephy-v0.1.3
```

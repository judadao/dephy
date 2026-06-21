#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPS_JSON="$ROOT_DIR/deps.json"

json_value() {
    key=$1
    if command -v jq >/dev/null 2>&1; then
        jq -r "$key // empty" "$DEPS_JSON"
    else
        return 1
    fi
}

workspace=$(json_value '.zephyr.workspace' || true)
if [ -z "$workspace" ]; then
    workspace="../zephyrproject"
fi

case "$workspace" in
    "~"/*) workspace="$HOME/${workspace#"~/"}" ;;
    /*) ;;
    *) workspace=$(realpath -m "$ROOT_DIR/$workspace") ;;
esac

if [ -x "$workspace/.venv/bin/west" ]; then
    WEST="$workspace/.venv/bin/west"
elif command -v west >/dev/null 2>&1; then
    WEST=$(command -v west)
else
    mkdir -p "$workspace"
    python3 -m venv "$workspace/.venv"
    "$workspace/.venv/bin/pip" install --quiet west
    WEST="$workspace/.venv/bin/west"
fi

if [ -x "$workspace/.venv/bin/pip" ]; then
    "$workspace/.venv/bin/pip" install --quiet jsonschema pyelftools ninja
fi

if [ ! -f "$workspace/.west/config" ]; then
    "$WEST" init "$workspace"
fi

if command -v jq >/dev/null 2>&1; then
    modules=$(jq -r '.zephyr.modules[]? // empty' "$DEPS_JSON")
else
    modules="hal_espressif"
fi

if [ -z "$modules" ]; then
    printf 'no Zephyr modules listed in deps.json\n'
    exit 0
fi

missing_modules=""
for module in $modules; do
    case "$module" in
        hal_espressif)
            module_dir="$workspace/modules/hal/espressif" ;;
        mbedtls)
            module_dir="$workspace/modules/crypto/mbedtls" ;;
        tf-psa-crypto)
            module_dir="$workspace/modules/crypto/tf-psa-crypto" ;;
        *)
            module_dir="" ;;
    esac

    if [ -n "$module_dir" ] && [ ! -d "$module_dir/.git" ]; then
        missing_modules="$missing_modules $module"
    elif [ -z "$module_dir" ]; then
        missing_modules="$missing_modules $module"
    fi
done

if [ -z "$missing_modules" ] && [ "${DEPHY_FORCE_WEST_UPDATE:-0}" != "1" ]; then
    printf 'Zephyr modules already present; set DEPHY_FORCE_WEST_UPDATE=1 to refresh.\n'
else
    (cd "$workspace" && "$WEST" update ${missing_modules:-$modules})
fi

if [ -f "$workspace/.west/config" ]; then
    if ! "$workspace/.venv/bin/python3" -c 'import esptool; raise SystemExit(0 if tuple(map(int, esptool.__version__.split(".")[:3])) >= (5, 0, 2) else 1)' >/dev/null 2>&1; then
        (cd "$workspace" && "$WEST" packages pip --install)
    fi
fi

if [ -d "$workspace/modules/hal/espressif" ]; then
    if [ ! -d "$workspace/modules/hal/espressif/zephyr/blobs/lib" ]; then
        (cd "$workspace" && "$WEST" blobs fetch hal_espressif)
    else
        printf 'Espressif blobs already present; skipping blob fetch.\n'
    fi
fi

sdk_version_file="$workspace/zephyr/SDK_VERSION"
if [ -f "$sdk_version_file" ]; then
    sdk_version=$(cat "$sdk_version_file")
    sdk_dir="${ZEPHYR_SDK_INSTALL_DIR:-$HOME/zephyr-sdk-$sdk_version}"
    if [ -f "$sdk_dir/cmake/Zephyr-sdkConfig.cmake" ]; then
        printf 'Zephyr SDK available: %s\n' "$sdk_dir"
    else
        printf 'warning: Zephyr SDK not found at %s\n' "$sdk_dir" >&2
        printf '  Install it or set ZEPHYR_SDK_INSTALL_DIR before building.\n' >&2
    fi
fi

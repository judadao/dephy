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

if command -v west >/dev/null 2>&1; then
    WEST=$(command -v west)
elif [ -x "$workspace/.venv/bin/west" ]; then
    WEST="$workspace/.venv/bin/west"
else
    printf 'error: west not found; expected %s/.venv/bin/west or west in PATH\n' "$workspace" >&2
    exit 1
fi

if [ ! -f "$workspace/.west/config" ]; then
    printf 'error: west workspace not found at %s\n' "$workspace" >&2
    printf '  Run: %s init %s\n' "$WEST" "$workspace" >&2
    exit 1
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

(cd "$workspace" && "$WEST" update $modules)

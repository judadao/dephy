#!/bin/sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

for path in deps.json zephyr/CMakeLists.txt zephyr/Kconfig zephyr/module.yml; do
    if [ ! -f "$root/$path" ]; then
        echo "missing $path" >&2
        exit 1
    fi
done

python3 - "$root/deps.json" <<'PY'
import json
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
zephyr = data.get("zephyr", {})
if not zephyr.get("workspace"):
    raise SystemExit("missing zephyr.workspace")
if not (zephyr.get("board") or data.get("build", {}).get("board")):
    raise SystemExit("missing zephyr.board or build.board")
if not zephyr.get("modules"):
    raise SystemExit("missing zephyr.modules")
PY

grep -q "name: dephy_esp32" "$root/zephyr/module.yml"
grep -q "DEPHY_ESP32" "$root/zephyr/Kconfig"

echo "dephy ESP32 profile OK"

# TODO

Source of truth: `docs/todo.yaml`. Update YAML before starting or completing work.

## repo

- [x] Add docs/todo.yaml so the board platform repo is tracked globally.
- [ ] Align board-platform repository docs and scripts with the golden sample conventions.

## validation

- [ ] Add a smoke test for ESP32 board profile metadata and Zephyr module sync inputs.

## release

- [ ] Audit Dephy board-platform tags and document the version bump flow used by product deps.json files.

## performance

- [ ] Avoid redundant Zephyr module sync work when dependency pins have not changed.

#!/usr/bin/env bash
# Watch DMS session state and regenerate the custom theme whenever the
# wallpaper actually changes.
#
# session.json is only the trigger; the wallpaper path comes from IPC so we
# never depend on its JSON schema.

set -uo pipefail

STATE_DIR="$HOME/.local/state/DankMaterialShell"
MATUGEN_CONFIG="$HOME/.config/matugen/custom_config.toml"
MODE="dark"

# Which of matugen's candidate source colours to use. 0 is the dominant one,
# matching what DMS does internally. This MUST be set: without it matugen opens
# an interactive picker, and with no terminal attached the service would block
# forever waiting for an answer.
SOURCE_INDEX=0

last=""

regen() {
    local wall
    wall=$(dms ipc call wallpaper get 2>/dev/null) || return 0
    # In per-monitor mode this returns an error string, not a path.
    [[ -f "$wall" ]] || return 0
    [[ "$wall" == "$last" ]] && return 0

    # stdin closed as a second line of defence: if a future matugen version
    # prompts anyway, it fails fast instead of hanging.
    if matugen image "$wall" -m "$MODE" \
            --source-color-index "$SOURCE_INDEX" \
            -c "$MATUGEN_CONFIG" </dev/null >/dev/null 2>&1; then
        last="$wall"
        echo "theme regenerated from $wall"
    else
        echo "matugen failed for $wall" >&2
    fi
}

regen  # sync once at startup, in case the wallpaper changed while we were down

# Watch the directory, not the file: DMS writes state atomically via
# temp-file + rename, which replaces the inode and would silently detach a
# watch placed on session.json itself.
inotifywait -q -m -e close_write,moved_to --format '%f' "$STATE_DIR" |
while read -r file; do
    [[ "$file" == "session.json" ]] || continue
    sleep 0.3          # debounce bursts of writes
    while read -r -t 0.3 _; do :; done   # drain anything queued during the sleep
    regen
done

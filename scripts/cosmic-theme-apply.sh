#!/usr/bin/env bash
# Split the matugen-generated COSMIC theme (cosmic/theme.ron) into the
# one-file-per-field layout libcosmic reads, so Cosmic Files (and any other
# libcosmic app) picks up the new colors. Run as matugen's post_hook.
#
# Sections in the input start with a line "@@ <field>"; everything before the
# first marker (the header comments) is ignored.

set -euo pipefail

SRC="${1:-$HOME/dotfiles/cosmic/theme.ron}"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/cosmic/com.system76.CosmicTheme.Dark/v2"

mkdir -p "$DEST"

# Write each field to a temp file and rename it into place: libcosmic watches
# this directory and live-reloads, so it must never see a half-written file.
awk -v dest="$DEST" '
    function flush() {
        if (field != "") {
            close(tmp)
            system("mv -f \"" tmp "\" \"" dest "/" field "\"")
        }
    }
    /^@@ / {
        flush()
        field = $2
        tmp = dest "/." field ".tmp"
        printf "" > tmp
        next
    }
    field != "" && NF { print >> tmp }
    END { flush() }
' "$SRC"

# libcosmic apps only live-reload the theme through cosmic-settings-daemon's
# D-Bus watcher, which isn't running outside COSMIC, so long-running ones keep
# whatever theme they started with. The file picker portal is the only one of
# those here; it's D-Bus activated, so stopping it is enough: the next file
# dialog starts a fresh copy with the new theme. (Cosmic Files itself picks the
# theme up the next time it's opened.)
pkill -f '^/usr/lib/xdg-desktop-portal-cosmic$' || true

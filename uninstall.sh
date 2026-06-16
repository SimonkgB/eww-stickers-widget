#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/.config/eww/sticker"
HYPR_EXECS="$HOME/.config/hypr/config/execs.lua"
AUTOSTART_ENTRY='"~/.config/eww/sticker/start.sh",'

# Stop EWW if running for this config
if eww --config "$TARGET" ping &>/dev/null 2>&1; then
  eww --config "$TARGET" close notes 2>/dev/null || true
  eww --config "$TARGET" kill 2>/dev/null || true
  echo "Stopped EWW widget."
fi

# Back up notes if they have content
NOTES="$TARGET/notes.txt"
if [ -f "$NOTES" ] && [ -s "$NOTES" ]; then
  BACKUP="$HOME/sticker-notes-backup.txt"
  cp "$NOTES" "$BACKUP"
  echo "Notes backed up to $BACKUP"
fi

if [ -d "$TARGET" ]; then
  rm -rf "$TARGET"
  echo "Uninstalled."
else
  echo "Nothing to remove at $TARGET"
fi

if [ -f "$HYPR_EXECS" ] && grep -Fq "$AUTOSTART_ENTRY" "$HYPR_EXECS"; then
  echo
  echo "Manual step needed:"
  echo "Remove this autostart entry from $HYPR_EXECS"
  echo "  $AUTOSTART_ENTRY"
fi

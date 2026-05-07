#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/.config/eww/sticker"

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

# Only remove a symlink — never delete a real directory
if [ -L "$TARGET" ]; then
  rm "$TARGET"
  echo "Uninstalled (symlink removed)."
elif [ -d "$TARGET" ]; then
  echo "Error: $TARGET is a real directory, not a symlink created by install.sh."
  echo "Remove it manually if you're sure."
  exit 1
else
  echo "Nothing to remove at $TARGET"
fi

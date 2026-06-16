#!/usr/bin/env bash
# Start EWW daemon and open the notes widget from sticker folder
TARGET="$HOME/.config/eww/sticker"
NOTES="$TARGET/notes.txt"
CONTENT="$(grep -vE '^(#|$)' "$NOTES" 2>/dev/null || true)"

[ -n "$CONTENT" ] || CONTENT="No notes yet..."

eww --config "$TARGET" ping >/dev/null 2>&1 || eww --config "$TARGET" daemon
eww --config "$TARGET" update "notes_text=$CONTENT"
eww --config "$TARGET" open notes

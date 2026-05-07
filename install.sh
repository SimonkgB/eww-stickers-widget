#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config/eww/sticker"

echo "Installing EWW sticker widget..."
echo "  repo:   $REPO_DIR"
echo "  target: $TARGET"

# Something else exists at the target — don't touch it
if [ -e "$TARGET" ]; then
  echo "Error: $TARGET already exists."
  echo "Remove or move it first, then re-run."
  exit 1
fi

mkdir -p "$TARGET"

for f in eww.yuck eww.scss start.sh open-notes.sh uninstall.sh; do
  cp "$REPO_DIR/$f" "$TARGET/$f"
done

touch "$TARGET/notes.txt"
chmod +x "$TARGET/start.sh" "$TARGET/open-notes.sh" "$TARGET/uninstall.sh"

echo ""
echo "Done. Start the widget with:"
echo "  $TARGET/start.sh"
echo ""
echo "Or add to your Hyprland autostart:"
echo "  exec-once = $TARGET/start.sh"

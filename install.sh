#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config/eww/sticker"

# Guard: don't run if the repo is already sitting at the target path.
# The install creates a symlink pointing here, so the repo must live elsewhere.
if [ "$REPO_DIR" = "$TARGET" ]; then
  echo "Error: this repo is already at $TARGET."
  echo "Clone it somewhere else first, e.g.:"
  echo "  git clone <url> ~/eww-sticker"
  echo "  cd ~/eww-sticker && ./install.sh"
  exit 1
fi

echo "Installing EWW sticker widget..."
echo "  repo:   $REPO_DIR"
echo "  target: $TARGET"

# Already installed and pointing here
if [ -L "$TARGET" ] && [ "$(readlink -f "$TARGET")" = "$REPO_DIR" ]; then
  echo "Already installed."
  exit 0
fi

# Something else exists at the target — don't touch it
if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
  echo "Error: $TARGET already exists."
  echo "Remove or move it first, then re-run."
  exit 1
fi

mkdir -p "$HOME/.config/eww"
ln -s "$REPO_DIR" "$TARGET"

touch "$REPO_DIR/notes.txt"
chmod +x "$REPO_DIR/install.sh" "$REPO_DIR/uninstall.sh" \
         "$REPO_DIR/start.sh" "$REPO_DIR/open-notes.sh"

echo ""
echo "Done. Start the widget with:"
echo "  $TARGET/start.sh"
echo ""
echo "Or add to your Hyprland autostart:"
echo "  exec-once = $TARGET/start.sh"

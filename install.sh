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

for f in eww.yuck eww.scss start.sh open-notes.lua uninstall.sh; do
  cp "$REPO_DIR/$f" "$TARGET/$f"
done

touch "$TARGET/notes.txt"
chmod +x "$TARGET/start.sh" "$TARGET/open-notes.lua" "$TARGET/uninstall.sh"

echo ""
echo "Done. Start the widget with:"
echo "  $TARGET/start.sh"
echo ""
echo "Hyprland Lua autostart example (~/.config/hypr/config/execs.lua):"
echo '  local startup = {'
echo "    \"$TARGET/start.sh\","
echo '  }'
echo ""
echo "Optional Hyprland Lua rules (~/.config/hypr/config/rules.lua):"
echo '  hl.window_rule({ match = { class = "notesedit" }, float = true })'
echo '  hl.window_rule({ match = { class = "notesedit" }, size = "420 320" })'
echo '  hl.window_rule({ match = { class = "notesedit" }, move = "20 200" })'

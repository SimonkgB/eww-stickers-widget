#!/usr/bin/env sh
set -eu

# Final on-screen position/size (pixels)
X_FINAL=20
Y_FINAL=200
W=420
H=320

# Off-screen spawn position (negative X means left of the visible area)
X_OFF=-500
Y_OFF=200

TITLE="notesedit"

FILE="$HOME/.config/eww/sticker/notes.txt"
mkdir -p "$(dirname "$FILE")"
touch "$FILE"

# Helper: find the window address by exact title
get_addr() {
  hyprctl clients -j | jq -r --arg t "$TITLE" '
    .[]
    | select(((.title | tostring?) // "") == $t)
    | .address
  ' | head -n1
}

# If already open, focus it and exit
addr="$(get_addr || true)"
if [ -n "${addr:-}" ] && [ "$addr" != "null" ]; then
  hyprctl dispatch focuswindow "address:$addr"
  exit 0
fi

# Spawn: float + size + move OFFSCREEN at map-time (no tiling flash)
# NOTE: rules are separated by semicolons and wrapped in quotes. :contentReference[oaicite:1]{index=1}
hyprctl dispatch exec "[float;size $W $H;move $X_OFF $Y_OFF]" \
  "kitty --title $TITLE -e sh -lc '
    FILE=\"$FILE\"

    push() {
      CONTENT=\$(grep -vE \"^(#|$)\" \"\$FILE\" 2>/dev/null || true)
      [ -n \"\$CONTENT\" ] || CONTENT=\"No notes yet...\"
      eww --config ~/.config/eww/sticker update \"notes_text=\$CONTENT\"
    }

    push

    inotifywait -m -q -e close_write \"\$FILE\" | while read -r _; do
      push
    done &
    WPID=\$!

    nano \"\$FILE\"

    kill \$WPID 2>/dev/null || true
    push
  '"

# Wait for the window to appear, then move it into place (animated by Hyprland)
addr=""
for _ in $(seq 1 300); do
  addr="$(get_addr || true)"
  if [ -n "${addr:-}" ] && [ "$addr" != "null" ]; then
    break
  fi
  sleep 0.01
done

# If it never appeared, just exit quietly
[ -n "${addr:-}" ] && [ "$addr" != "null" ] || exit 0

# Move to final position (this is the "slide in" step)
hyprctl dispatch movewindowpixel "exact $X_FINAL $Y_FINAL, address:$addr"

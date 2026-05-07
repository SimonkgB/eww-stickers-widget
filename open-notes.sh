#!/usr/bin/env sh
set -eu

X=20
Y=200
W=420
H=320

TITLE="notesedit"

FILE="$HOME/.config/eww/sticker/notes.txt"
mkdir -p "$(dirname "$FILE")"
touch "$FILE"

get_addr() {
  hyprctl clients -j | jq -r --arg t "$TITLE" '
    .[] | select(.initialTitle == $t) | .address
  ' | head -n1
}

# If already open, focus it and exit
addr="$(get_addr || true)"
if [ -n "${addr:-}" ] && [ "$addr" != "null" ]; then
  hyprctl dispatch focuswindow "address:$addr"
  exit 0
fi

# Spawn at the target position with a native slide-left open animation.
# animationstyle is a window rule Hyprland applies at map time - no timing
# race with movewindowpixel needed.
hyprctl dispatch exec "[float;size $W $H;move $X $Y;animationstyle slide left]kitty --title $TITLE -e sh -lc '
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

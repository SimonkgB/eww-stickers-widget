#!/usr/bin/env lua
local terminal = os.getenv("TERMINAL") or "kitty"
local editor   = os.getenv("EDITOR")   or "nano"
local title    = "notesedit"
local file     = os.getenv("HOME") .. "/.config/eww/sticker/notes.txt"

local function shquote(value)
    return string.format("%q", value)
end

os.execute("mkdir -p " .. shquote(file:match("(.+)/")))
os.execute("touch " .. shquote(file))

-- Check if already open
local handle = io.popen(
    "hyprctl clients -j | jq -r --arg t "
        .. shquote(title)
        .. " '.[] | select(.initialClass == $t or .class == $t or .initialTitle == $t or .title == $t) | .address' | first'"
)
local addr = handle:read("*l")
handle:close()

if addr and addr ~= "" and addr ~= "null" then
    os.execute("hyprctl dispatch focuswindow " .. shquote("address:" .. addr))
    return
end

local inner = string.format(
    "sh -lc 'FILE=%q; EDITOR=%q; push() { CONTENT=$(grep -vE \"^(#|$)\" \"$FILE\" 2>/dev/null || true); [ -n \"$CONTENT\" ] || CONTENT=\"No notes yet...\"; eww --config ~/.config/eww/sticker update \"notes_text=$CONTENT\"; }; push; while inotifywait -q -e close_write \"$FILE\" >/dev/null; do push; done & WPID=$!; $EDITOR \"$FILE\"; kill $WPID 2>/dev/null || true; push'",
    file, editor
)

os.execute(string.format(
    "%s --app-id %s -T %s -e %s >/dev/null 2>&1 &",
    shquote(terminal), shquote(title), shquote(title), inner
))

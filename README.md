# EWW Notes Widget

A simple sticky notes widget for EWW (ElKowar's Wacky Widgets) that displays persistent notes on your desktop.

## Features

- Displays notes from a text file
- Click to edit notes
- Automatically refreshes every 5 minutes
- Minimal design that stays out of the way

## Installation

1. git clone repo to local machine
2. Run `~/eww-stickers-widget/install.sh`
3. Add to your window manager's autostart: `~/.config/eww/sticker/start.sh`
4. A file `~/notes.txt` will be created, you interact with the widget in the termianl, or by clicking on the sticker on your home screen

## Files

- `eww.yuck` - Main widget configuration
- `eww.scss` - Primary styles
- `notes.txt` - Your notes content
- `open-notes.sh` - Script to edit notes
- `start.sh` - Startup script

## Removal
Run the command `~/.config/eww/sticker/uninstall.sh`, it will remove all files and timers

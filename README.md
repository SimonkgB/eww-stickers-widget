# EWW Notes Widget

A simple sticky notes widget for EWW (ElKowar's Wacky Widgets) that displays persistent notes on your desktop.

## Features

- Displays notes from a text file
- Click to edit notes
- Automatically refreshes every 5 minutes
- Minimal design that stays out of the way

## Installation

1. Copy all files to your EWW config directory
2. Add to your window manager's autostart: `./start.sh`
3. Edit `notes.txt` to add your notes

## Files

- `eww.yuck` - Main widget configuration
- `eww.scss` - Primary styles
- `eww_stickers.scss` - Additional styling
- `notes.txt` - Your notes content
- `open-notes.sh` - Script to edit notes
- `start.sh` - Startup script

## Usage

Run `./start.sh` to start the EWW daemon and display the notes widget.

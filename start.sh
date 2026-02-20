#!/bin/bash
# Start EWW daemon and open the notes widget from sticker folder
cd ~/.config/eww/sticker
eww daemon && eww open notes

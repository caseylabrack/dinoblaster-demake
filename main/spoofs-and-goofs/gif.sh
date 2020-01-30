#!/bin/sh

palette="/tmp/palette.png"
filters="fps=30"

ffmpeg -v warning -i frames/dino-%04d.png -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i frames/dino-%04d.png -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $1

#!/bin/zsh

if [ -z "$1" ]; then
    echo "Usage: download_url.sh '<YouTube URL>'"
    exit 1
fi

cd "$HOME/Projects/music-pomodoro/mp3"

yt-dlp -x --audio-format mp3 -o "%(title)s.%(ext)s" "$1"
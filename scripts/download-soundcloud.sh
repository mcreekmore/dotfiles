#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "Error: Must pass soundcloud url."
    exit 1
fi

mkdir temp
cd temp || exit

yt-dlp -o '%(title)s.%(ext)s' --embed-metadata --embed-thumbnail --metadata-from-title "%(album)s" "$1"

if [ $? -eq 0 ]; then
    echo "Download successful."
    destination="/mnt/unraid/data/media/music"
    downloaded_file=$(find . -type f | head -n 1)
    cp "$downloaded_file" "$destination"
    echo "File copied to $destination"
else
    echo "Download failed. Please check the URL and try again."
fi

cd ..
rm -r "temp"

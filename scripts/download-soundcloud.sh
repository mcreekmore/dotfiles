#!/usr/bin/env bash

download_location="/mnt/unraid/data/media/music"

if [ $# -lt 2 ]
  then
    echo "Error: Must pass soundcloud url and a folder name."
    exit 1
fi

soundcloud_url=$1
folder_name=$2

mkdir temp
cd temp || exit

yt-dlp -o '%(title)s.%(ext)s' --embed-metadata --embed-thumbnail --metadata-from-title "%(album)s" "$1"

if [ $? -eq 0 ]; then
    echo "Download successful."
    destination="$download_location/$folder_name"
    mkdir -p "$destination"

    for downloaded_file in *; 
    do
        cp "$downloaded_file" "$destination"
        echo "File copied to $destination: $downloaded_file"
    done
else
    echo "Download failed. Please check the URL and try again."
fi

cd ..
rm -r "temp"

#!/usr/bin/env bash
set -e

YOUTUBE_FORMATS=$(youtube-dl -F "$1")

if [[ "$YOUTUBE_FORMATS" == *"DASH video"* ]]; then

    # VIDEO_NAME=$(youtube-dl --get-filename "$1" --restrict-filenames)
    # Video_NAME=$(youtube-dl "$1" --get-filename -o "%(title)s.%(ext)s" --restrict-filenames)
    # VIDEO_NAME="$2-$VIDEO_NAME"
    VIDEO_NAME="$2.mp4" 
    VIDEO_NAME_TMP="$VIDEO_NAME.tmp"

    echo "Filename: $VIDEO_NAME"

    if [ -e "$VIDEO_NAME" ]; then
	echo "File already exists, aborting..."
	exit
    fi

    # Strip dashes from the beginning of the ID to avoid command line errors
    VIDEO_ID=`youtube-dl --get-id "$1" | sed "s/^-/_/"`

    #VIDEO_FORMAT=`echo "$YOUTUBE_FORMATS" | grep mp4 |  fgrep "DASH video" | head -n 2 | tail -n 1`
    VIDEO_FORMAT=`echo "$YOUTUBE_FORMATS" | grep mp4 |  fgrep "DASH video" | head -n 1`
    VIDEO_FORMAT_ID=`echo "$VIDEO_FORMAT" | cut -d' ' -f 1`
    VIDEO_FORMAT_NAME=`echo "$VIDEO_FORMAT" | cut -d' ' -f 4,5`

   AUDIO_FORMAT=`echo "$YOUTUBE_FORMATS" | fgrep "DASH audio" | head -n 1`
    AUDIO_FORMAT_ID=`echo "$AUDIO_FORMAT" | cut -d' ' -f 1`
    AUDIO_FORMAT_NAME=`echo "$AUDIO_FORMAT" | cut -d' ' -f 4,5`

	echo "Using formats: video=$VIDEO_FORMAT_ID, audio=$AUDIO_FORMAT_ID"

    youtube-dl -f $VIDEO_FORMAT_ID -o "${VIDEO_ID}.vid" "$1"
    youtube-dl -f $AUDIO_FORMAT_ID -o "${VIDEO_ID}.aud" "$1"

    echo -n "Combining files..."

    ffmpeg -loglevel quiet -i "$VIDEO_ID.vid" -i "$VIDEO_ID.aud" -f mp4 "$VIDEO_NAME_TMP"
    rm "$VIDEO_ID".*
    mv "$VIDEO_NAME_TMP" "$VIDEO_NAME"

    echo " done!"
else
    echo " can't do anything"
    youtube-dl "$1"
fi

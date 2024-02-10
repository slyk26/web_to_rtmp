#!/bin/bash

echo "starting pulseaudio"
pulseaudio -D --system

echo "Starting X virtual framebuffer using: Xvfb $DISPLAY -ac -screen 0 $XVFB_WHD -nolisten tcp"
Xvfb $DISPLAY -nocursor -ac -screen 0 $XVFB_WHD -nolisten tcp &
sleep 3
# # Execute CMD (original CMD of this Dockerfile gets overridden in actor build)
echo "Executing main command"
DISPLAY=$DISPLAY /bin/webtortmp & ffmpeg -f alsa -ac 2 -i pulse -f x11grab -draw_mouse 0 -framerate 40 -video_size 800x700 \
                                    -i $DISPLAY.0+0,0 -c:v libx264 -preset veryfast -b:v 1984k -maxrate 1984k -bufsize 3968k \
                                    -vf "format=yuv420p" -g 80 -c:a aac -b:a 168k -ar 44100 \
                                    -f flv rtmp://live.twitch.tv/app/{stream_key} & wait

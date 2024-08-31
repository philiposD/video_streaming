#!/bin/bash

# Start Nginx
/usr/local/nginx/sbin/nginx &

sleep 2
# Wait until the file exists
while [ ! -f /tmp/hls/4k1.mov ]; do
    echo "Waiting for /tmp/hls/4k1.mov to become available..."
    sleep 2
done

# Start FFmpeg with the looping stream
ffmpeg -re -stream_loop -1 -i /tmp/hls/4k1.mov -c:v libx264 -preset veryfast -tune zerolatency -maxrate 6000k -bufsize 6000k -c:a aac -ar 44100 -b:a 128k -f flv rtmp://localhost:1935/live/stream1 &
ffmpeg -re -stream_loop -1 -i /tmp/hls/4k2.mov -c:v libx264 -preset veryfast -tune zerolatency -maxrate 6000k -bufsize 6000k -c:a aac -ar 44100 -b:a 128k -f flv rtmp://localhost:1935/live/stream2

# Wait for all background processes to finish (optional)
wait

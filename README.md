# Intro

This is a small config for using Docker and run video streams.
There are 2 video streams running, in order to run only 1, please modify the files to reflect on that.

```
start.sh
```
Used for running start command on docker.

```
index.html
```
Used for viewing the streams. Comment the lines that won't be used.
# How to
### Build image:
```
docker build -t nginx-rtmp-ffmpeg .
```

### Run container:
```
docker run -p 1935:1935 -p 8080:8080 nginx-rtmp-ffmpeg
```

### Verify
1) Trying to load the root index.html
- Open the URL: http://localhost:8080/
-------
2) Using VLC:
- Open network and check URL: 
    - http://localhost:8080/hls/stream1.m3u8
    - http://localhost:8080/hls/stream2.m3u8

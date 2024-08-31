# Use an Alpine Linux image as a base
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    curl \
    git \
    ffmpeg \
    bash

# Download and build Nginx with the RTMP module
RUN mkdir -p /usr/src \
    && cd /usr/src \
    && curl -L http://nginx.org/download/nginx-1.21.6.tar.gz | tar xz \
    && git clone https://github.com/arut/nginx-rtmp-module.git \
    && cd nginx-1.21.6 \
    && ./configure --with-http_ssl_module --add-module=/usr/src/nginx-rtmp-module \
    && make \
    && make install

# Create the directory where the HLS segments will be stored
RUN mkdir -p /tmp/hls

# Create the directory for nginx mime.types and copy it
RUN mkdir -p /etc/nginx \
    && cp /usr/local/nginx/conf/mime.types /etc/nginx/mime.types

# Copy the nginx configuration file to the container
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

COPY ./videos/4k1.mov /tmp/hls/4k1.mov
COPY ./videos/4k2.mov /tmp/hls/4k2.mov

# Copy the start script to the container
COPY start.sh /start.sh

# Make the start script executable
RUN chmod +x /start.sh

# Expose ports for RTMP and HTTP
EXPOSE 1935 8080

# Run the start script when the container starts
CMD ["/start.sh"]

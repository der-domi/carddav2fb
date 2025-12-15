FROM alpine:3.23
LABEL description="Download CardDAV VCards and upload as phonebook to AVM FRITZ!Box"

VOLUME [ "/data" ]

# Install dependencies for carddav2fb
RUN set -xe && \
    apk update && apk upgrade && \
    apk add --no-cache --virtual=run-deps \
        # for CLI
        php84-dev \
        # for carddav2fb
        php84-curl \
        php84-dom \
        php84-ftp \
        php84-gd \
        php84-mbstring \
        php84-simplexml \
        php84-tokenizer \
        php84-xml \
        php84-xmlreader \
        php84-xmlwriter \
        composer && \
    apk del --progress --purge && \
    rm -rf /var/cache/apk/*

# Copy carddav2fb and install php dependencies
COPY . /srv
RUN mkdir -p /data && \
    cd /srv && \
    composer install --no-dev && \
    chmod +x /srv/carddav2fb /srv/docker-entrypoint && \
    ln -s /data/config.php .

ENTRYPOINT [ "/srv/docker-entrypoint" ]

FROM debian:buster

ENV VER=5.26.2
ARG MMDB_USER
ARG MMDB_PASSWORD
ARG MMDB_HOST

WORKDIR /root

RUN apt-get update && apt-get install -y \
        curl \
    && rm -rf /var/cache/apt/*
RUN curl -o mattermost.tar.gz "https://releases.mattermost.com/${VER}/mattermost-${VER}-linux-amd64.tar.gz"
RUN tar -xzf mattermost.tar.gz

COPY docker-entrypoint.sh mattermost/
COPY config.json mattermost/config/config.json

# Modify config values
RUN sed -i \
      -e "s;{{ DBCONN }};postgres://${MMDB_USER}:${MMDB_PASSWORD}@${MMDB_HOST}:5432/mattermost?sslmode=disable\&connect_timeout=10;" \
    mattermost/config/config.json

# Add & change to user
RUN useradd --system --user-group mattermost \
    && chown -R mattermost:mattermost mattermost/ \
    && chmod -R g+w mattermost/
# USER mattermost

EXPOSE 8065

ENTRYPOINT ["bash", "mattermost/docker-entrypoint.sh"]

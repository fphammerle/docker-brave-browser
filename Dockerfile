FROM docker.io/debian:10.8-slim

# https://brave.com/linux/#release-channel-installation
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        gnupg \
    && apt-key adv --keyserver pool.sks-keyservers.net \
        --recv-keys D8BAD4DE7EE17AF52A834B2D0BB75829C2D4E821 \
    && rm -rf /var/lib/apt/lists/* \
    && echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        > /etc/apt/sources.list.d/brave-browser-release.list \
    && useradd --create-home browser

ARG BRAVE_BROWSER_PACKAGE_VERSION=1.20.103
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        brave-browser=$BRAVE_BROWSER_PACKAGE_VERSION \
    && rm -rf /var/lib/apt/lists/* \
    && find / -xdev -type f -perm /u+s -exec chmod -c u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod -c g-s {} \;

USER browser
#CMD ["brave-browser"] podman
CMD ["brave-browser", "--no-sandbox"]

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="brave browser" \
    org.opencontainers.image.source="https://github.com/fphammerle/docker-brave-browser" \
    org.opencontainers.image.revision="$REVISION"

FROM docker.io/debian:10.8-slim

# https://brave.com/linux/#release-channel-installation
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
    && rm -rf /var/lib/apt/lists/* \
    && curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
        | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - \
    && echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        > /etc/apt/sources.list.d/brave-browser-release.list \
    && useradd --create-home browser

RUN apt-get update \
    && apt-get install --yes --no-install-recommends brave-keyring brave-browser \
    && rm -rf /var/lib/apt/lists/*

USER browser
CMD ["brave-browser", "--no-sandbox"]

FROM ubuntu:18.04

# https://brave-browser.readthedocs.io/en/latest/installing-brave.html#linux
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        gnupg2 \
    && curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
        | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - \
    && echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ bionic main" \
        > /etc/apt/sources.list.d/brave-browser-release.list

RUN apt-get update \
    && apt-get install --yes --no-install-recommends brave-keyring brave-browser

RUN useradd --create-home browser
USER browser
CMD ["brave-browser", "--no-sandbox"]

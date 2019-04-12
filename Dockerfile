FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install --yes --no-install-recommends firefox

RUN useradd --create-home fox
USER fox
CMD ["firefox"]

FROM debian:buster-slim

ARG TARGETPLATFORM

WORKDIR /app

COPY . .

RUN set -ex \
  && if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then export TARGETPLATFORM=amd64; fi \
  && if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then export TARGETPLATFORM=arm64; fi \
  && mv "layinbeddings-linux-$TARGETPLATFORM" /usr/local/bin/layinbeddings


# $USER name, and data $DIR to be used in the 'final' image
ARG USER=sekulicd
ARG DIR=/home/sekulicd

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates

# NOTE: Default GID == UID == 1000
RUN adduser --disabled-password \
            --home "$DIR/" \
            --gecos "" \
            "$USER"
USER $USER

# Prevents 'VOLUME $DIR/.layinbeddings/' being created as owned by 'root'
RUN mkdir -p "$DIR/.layinbeddings/"

# Expose volume containing all layinbeddings data
VOLUME $DIR/.layinbeddings/

ENTRYPOINT [ "layinbeddings" ]
	
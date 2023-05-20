# syntax=docker/dockerfile:1

# Build container
FROM ghcr.io/linuxserver/baseimage-alpine:3.17 AS buildstage

ARG MOD_VERSION

RUN mkdir -p /root-layer/cloudflared
WORKDIR /src

RUN \
  apk add --no-cache \
    build-base \
    git \
    go

ENV GO111MODULE=on \
    CGO_ENABLED=0

RUN \
  if [ -z "${MOD_VERSION}" ]; then \
    curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest \
      | jq -rc ".tag_name" \
      | xargs -I TAG sh -c 'git -c advice.detachedHead=false clone https://github.com/cloudflare/cloudflared --depth=1 --branch TAG .'; \
  else \
    git -c advice.detachedHead=false clone https://github.com/cloudflare/cloudflared --depth=1 --branch ${MOD_VERSION} .; \
  fi

RUN GOOS=linux GOARCH=amd64 make cloudflared
RUN mv cloudflared /root-layer/cloudflared/cloudflared-amd64

RUN GOOS=linux GOARCH=arm64 make cloudflared
RUN mv cloudflared /root-layer/cloudflared/cloudflared-arm64

RUN GOOS=linux GOARCH=arm make cloudflared
RUN mv cloudflared /root-layer/cloudflared/cloudflared-armhf

COPY root/ /root-layer/

## Single layer deployed image ##
FROM scratch

LABEL maintainer="Spunkie"

# Add files from buildstage
COPY --from=buildstage /root-layer/ /

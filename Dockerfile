# syntax=docker/dockerfile:1

FROM scratch

LABEL maintainer="chooban"

COPY root/drivethrurpg.py /app/calibre-web/cps/metadata_provider/drivethrurpg.py

FROM alpine:latest
MAINTAINER Will Palmer <will@steelhive.com>

ENV PKG_RSA https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub
ENV GLIBC_VER 2.25-r0
ENV GLIBC_APK https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk

RUN apk update && \
    apk add --no-cache wget openssl unzip gettext ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub "$PKG_RSA" && \
    wget -q "$GLIBC_APK" && \
    apk add "glibc-$GLIBC_VER.apk" && \
    rm "glibc-$GLIBC_VER.apk" && \
    rm -fR /var/cache/apk/*

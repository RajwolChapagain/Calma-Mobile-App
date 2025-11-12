FROM alpine:latest

WORKDIR /home

RUN apk update && apk upgrade && apk add nix && apk add git

RUN echo "extra-experimental-features = nix-command flakes" >> /etc/nix/nix.conf
RUN NIX_REMOTE=local

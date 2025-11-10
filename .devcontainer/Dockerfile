FROM alpine:latest

WORKDIR /home

RUN apk update && apk upgrade && apk add nix

RUN echo "extra-experimental-features = nix-command flakes" >> /etc/nix/nix.conf

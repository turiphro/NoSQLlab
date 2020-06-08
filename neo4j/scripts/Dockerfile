FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install \
    httpie ruby ruby-dev \
    jq \
    build-essential \
    net-tools dnsutils # network debugging

RUN gem install faraday

COPY . /scripts
WORKDIR /scripts

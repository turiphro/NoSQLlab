FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install \
    httpie ruby ruby-dev \
    jq \
    redis-tools libhiredis-dev \
    build-essential \
    netcat net-tools dnsutils # network debugging

RUN gem install redis hiredis

COPY . /scripts
WORKDIR /scripts

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install \
    httpie ruby ruby-dev libxslt-dev libxml2-dev \
    build-essential \
    net-tools dnsutils # network debugging

RUN gem install libxml-ruby couchrest

COPY . /scripts
WORKDIR /scripts

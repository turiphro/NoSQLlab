FROM ubuntu:16.04

RUN apt-get update \
    && apt-get -y install \
    httpie ruby \
    net-tools dnsutils # network debugging

RUN gem install riak-client

COPY . /scripts
WORKDIR /scripts

FROM mongo:3.4

RUN apt-get update \
    && apt-get -y install \
    gcc g++ make \
    ruby ruby-dev

RUN gem install mongo

COPY . /scripts
WORKDIR /scripts


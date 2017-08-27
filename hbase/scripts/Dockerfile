#FROM ubuntu:16.04
FROM smizy/hbase:1.2.6-alpine

RUN apk update && \
    apk add --no-cache \
    curl \
    gcc g++ make \
    ruby ruby-dev ruby-irb ruby-rdoc

RUN gem install rspec thrift

RUN mkdir /scripts

# generate Ruby thrift files
# NOTE: if this section fails, just comment it out. The local example will be run.
RUN apk add ca-certificates wget \
	&& update-ca-certificates
RUN echo https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-src.tar.gz
ENV SRC /usr/local/src
RUN mkdir ${SRC}
RUN wget -q -O - \
	https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-src.tar.gz \
	| tar -xzf - -C ${SRC}
RUN wget -q -O - \
    http://www-eu.apache.org/dist/thrift/0.10.0/thrift-0.10.0.tar.gz \
    | tar -xzf - -C ${SRC}
RUN cd ${SRC}/thrift-0.10.0/ \
    && ./configure --without-tests \
    && make && make install # takes a few minutes
RUN cd /scripts \
    && thrift --gen rb ${SRC}/hbase-${HBASE_VERSION}/hbase-thrift/src/main/resources/org/apache/hadoop/hbase/thrift/Hbase.thrift

# if you have a local copy:
#COPY wikipedia.xml.bz2 /wikipedia.xml.bz2

COPY . /scripts
WORKDIR /scripts


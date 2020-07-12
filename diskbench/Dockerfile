FROM repo.home.local/tlhakhan/os/centos:centos8

ENV FIO_VERSION=3.20

# fio build tools
RUN yum makecache && \
    yum install -y gcc make nodejs

# build fio
RUN mkdir /fio && \
    cd /fio && \
    curl -o- https://repo.home.local/artifactory/downloads/axboe/fio/archive/fio-${FIO_VERSION}.tar.gz | tar -zxv -f - --strip 1 -C /fio &&\
    ./configure && \
    make && \
    make install

# test area
RUN mkdir /fio_test

WORKDIR /bench

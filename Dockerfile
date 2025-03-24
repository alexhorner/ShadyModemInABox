FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y && apt-get install build-essential autoconf gcc-multilib g++-multilib git nano ppp -y && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN git clone https://github.com/yatevoip/yate.git

WORKDIR /root/yate
RUN ./autogen.sh && ./configure
RUN make && make install-noapi

WORKDIR /root
RUN git clone https://github.com/Shadytel/shadysoftmodem.git

WORKDIR /root/shadysoftmodem
RUN git clone https://github.com/Shadytel/pkg-sl-modem.git
RUN make

RUN ldconfig

WORKDIR /
COPY yate.conf.d .

ENTRYPOINT ["yate", "-c", "."]

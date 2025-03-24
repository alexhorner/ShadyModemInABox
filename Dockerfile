FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y && apt-get install build-essential autoconf gcc-multilib g++-multilib git nano wget ppp -y && rm -rf /var/lib/apt/lists/*

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
RUN wget https://github.com/krallin/tini/releases/download/v0.19.0/tini -O /usr/sbin/tini && chmod +x /usr/sbin/tini

ENTRYPOINT ["tini", "yate", "--"]
CMD ["-c", "/yate.conf.d"]

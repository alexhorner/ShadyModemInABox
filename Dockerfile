#Compilation
FROM ubuntu:24.04 AS build

RUN apt-get update && apt-get upgrade -y && apt-get install build-essential autoconf doxygen gcc-multilib g++-multilib git nano wget -y && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN git clone https://github.com/yatevoip/yate.git

WORKDIR /root/yate
RUN ./autogen.sh && ./configure
RUN mkdir /opt/yate && make && make install DESTDIR=/opt/yate

WORKDIR /root
RUN git clone https://github.com/Shadytel/shadysoftmodem.git

WORKDIR /root/shadysoftmodem
RUN git clone https://github.com/Shadytel/pkg-sl-modem.git
RUN make

RUN wget https://github.com/krallin/tini/releases/download/v0.19.0/tini -O /usr/sbin/tini && chmod +x /usr/sbin/tini

#Final image
FROM ubuntu:24.04

RUN dpkg --add-architecture i386 && apt-get update && apt-get upgrade -y && apt-get install nano ppp libc6:i386 libstdc++6:i386 -y && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/yate/ /
COPY --from=build /root/shadysoftmodem/inbound_modem /usr/bin/inbound_modem
COPY --from=build /usr/sbin/tini /usr/sbin/tini
COPY answer_echo.sh /answer_echo.sh

RUN ln -s /usr/bin/inbound_modem /usr/bin/inbound_modem_attach

RUN ldconfig

WORKDIR /yate.conf.d
COPY yate.conf.d/ .

ENTRYPOINT ["tini", "yate", "--"]
CMD ["-c", "/yate.conf.d"]

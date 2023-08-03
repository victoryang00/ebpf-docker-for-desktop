FROM docker/for-desktop-kernel:5.10.76-505289bcc85427a04d8d797e06cbca92eee291f4 AS ksrc

LABEL maintainer="zeonll@outlook.com"

FROM ubuntu:23.04

WORKDIR /
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

RUN apt-get update
RUN apt install -y kmod wget
RUN apt install -y make gcc flex bison libelf-dev bc 
RUN apt install -y libssl-dev vim git clang libbpf-dev libclang-dev libcxxopts-dev libfmt-dev librange-v3-dev
RUN wget http://launchpadlibrarian.net/605552811/libbpf0_0.8.0-1_amd64.deb && wget http://launchpadlibrarian.net/605552807/libbpf-dev_0.8.0-1_amd64.deb && dpkg -i ./libbpf0_0.8.0-1_amd64.deb && dpkg -i ./libbpf-dev_0.8.0-1_amd64.deb

COPY linuxkit-dl.sh /root
COPY linuxkit-complier.sh /root

RUN sh /root/linuxkit-dl.sh 
RUN echo "download success"

RUN sh /root/linuxkit-complier.sh
RUN echo "complier successs"

RUN git clone https://github.com/SlugLab/CXLMemSim
RUN cd CXLMemSim
RUN sed -i 's/NL_SET_ERR_MSG_MOD/\/\/NL_SET_ERR_MSG_MOD/g' /usr/src/linux-headers-`uname -r`/include/net/flow_offload.h
RUN mkdir build && cd build && cmake .. && make -j

CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash

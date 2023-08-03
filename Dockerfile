FROM docker/for-desktop-kernel:5.10.76-505289bcc85427a04d8d797e06cbca92eee291f4 AS ksrc

LABEL maintainer="zeonll@outlook.com"

FROM ubuntu:23.04

WORKDIR /

RUN apt-get update
RUN apt install -y kmod wget
RUN apt install -y make gcc flex bison libelf-dev bc cmake linux-headers-`uname -r`
RUN apt install -y libssl-dev vim git clang libbpf-dev libclang-dev libcxxopts-dev libfmt-dev librange-v3-dev
RUN wget http://launchpadlibrarian.net/605552811/libbpf0_0.8.0-1_amd64.deb && wget http://launchpadlibrarian.net/605552807/libbpf-dev_0.8.0-1_amd64.deb && dpkg -i ./libbpf0_0.8.0-1_amd64.deb && dpkg -i ./libbpf-dev_0.8.0-1_amd64.deb


RUN git clone https://github.com/SlugLab/CXLMemSim RUN cd CXLMemSim
RUN sed -i 's/NL_SET_ERR_MSG_MOD/\/\/NL_SET_ERR_MSG_MOD/g' /usr/src/linux-headers-`uname -r`/include/net/flow_offload.h
RUN mkdir build && cd build && cmake .. && make -j

CMD mount -t debugfs debugfs /sys/kernel/debug && cd /CXLMemSim/build && LOGV=1 ./CXL-MEM-Simulator -t ./microbench/many_calloc -i 5 -c 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14

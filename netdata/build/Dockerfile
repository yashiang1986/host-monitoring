FROM nvidia/cuda:10.0-runtime-ubuntu16.04

ENV CUDA_DEVICE_ORDER=PCI_BUS_ID

COPY files/kickstart.sh /tmp

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget vim-tiny && \
    bash /tmp/kickstart.sh --dont-wait --non-interactive -i netdata-all && \
    wget --no-check-certificate https://github.com/netdata/netdata/releases/download/v1.16.0/netdata-v1.16.0.tar.gz -P /tmp &&  \
    cd /tmp && tar zxvf netdata-v1.16.0.tar.gz && mv netdata-v1.16.0 netdata && cd netdata && \
    ./netdata-installer.sh --install / --dont-start-it --dont-wait && \
    mkdir -p /opt/netdata && cp -r packaging/installer/functions.sh /opt/netdata && \
    sed -i '/nvidia_smi/s/^# //g' /netdata/usr/lib/netdata/conf.d/python.d.conf && \
    START_CMD="\/netdata\/usr\/sbin\/netdata\ \-\D\ \-\s\ \/host" && sed -i "s/^\(NETDATA_START_CMD\s*=\s*\).*\$/\1\"$START_CMD\"/" /opt/netdata/functions.sh &&\
    cd / && rm -rf /tmp/*

COPY files/start.sh /opt/netdata
COPY files/netdata.conf /netdata/etc/netdata/netdata.conf

ENTRYPOINT /opt/netdata/start.sh

FROM nvidia/cuda:10.0-runtime-ubuntu16.04

ENV CUDA_DEVICE_ORDER=PCI_BUS_ID

COPY files/kickstart.sh /tmp
COPY files/netdata_nv_plugin /tmp

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget vim-tiny && \
    bash /tmp/kickstart.sh --dont-wait --non-interactive -i netdata-all && \
    wget --no-check-certificate https://github.com/netdata/netdata/releases/download/v1.16.0/netdata-v1.16.0.tar.gz -P /tmp &&  \
    cd /tmp && tar zxvf netdata-v1.16.0.tar.gz && mv netdata-v1.16.0 netdata && cd netdata && \
    ./netdata-installer.sh --install / --dont-start-it --dont-wait && \
    cp -r /tmp/netdata_nv_plugin/nv.chart.py /netdata/usr/libexec/netdata/python.d && \
    cp -r /tmp/netdata_nv_plugin/python_modules/pynvml.py /netdata/usr/libexec/netdata/python.d/python_modules && \
    cp -r /tmp/netdata_nv_plugin/nv.conf /netdata/etc/netdata/python.d && \
    echo "nv: yes" >> /netdata/etc/netdata/python.d.conf && \
    mkdir -p /opt/netdata && cp -r packaging/installer/functions.sh /opt/netdata && \
    START_CMD="\/netdata\/usr\/sbin\/netdata\ \-\D\ \-\s\ \/host" && sed -i "s/^\(NETDATA_START_CMD\s*=\s*\).*\$/\1\"$START_CMD\"/" /opt/netdata/functions.sh &&\
    cd / && rm -rf /tmp/*

COPY files/start.sh /opt/netdata
COPY files/netdata.conf /netdata/etc/netdata/netdata.conf

ENTRYPOINT /opt/netdata/start.sh

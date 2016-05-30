FROM jerady/ubuntu:latest
MAINTAINER Jens Deters <mail@jensd.de>

RUN \
  apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes software-properties-common python-software-properties && \
  apt-add-repository -y ppa:mosquitto-dev/mosquitto-ppa && \
  apt-get -y update && \
  apt-get install -y mosquitto

COPY config /etc/mosquitto

EXPOSE 1883 8883
CMD /usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf -v

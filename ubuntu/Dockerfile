FROM ubuntu:16.04
MAINTAINER Jens Deters <mail@jensd.de>

RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

ENV VERSION   8
ENV UPDATE    74
ENV BUILD     02
ENV JRE_FILE  server-jre-${VERSION}u${UPDATE}-linux-x64.tar.gz
ENV JAVA_HOME /usr/java/default/jdk1.8.0_${UPDATE}
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  sed 's/main$/main universe/' -i /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y byobu curl git htop locate man unzip vim wget mc && \
  rm -rf /var/lib/apt/lists/*

RUN \
    curl --insecure --junk-session-cookies --location --remote-name --silent --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/${VERSION}u${UPDATE}-b${BUILD}/${JRE_FILE}  && \
    mkdir -p /usr/java/default && \
    tar xfz ${JRE_FILE} -C /usr/java/default && \
    update-alternatives --install /usr/bin/java java /usr/java/default/jdk1.8.0_${UPDATE}/bin/java 1 && \
    update-alternatives --install /usr/bin/jar  jar  /usr/java/default/jdk1.8.0_${UPDATE}/bin/jar  1 && \
    rm ${JRE_FILE} && \
    apt-get autoclean && apt-get --purge -y autoremove



# Define default command.
CMD ["bash"]

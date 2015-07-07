FROM phusion/baseimage:0.9.16
MAINTAINER MATSUI Shinsuke <poppen.jp@gmail.com>

RUN apt-get update && \
    apt-get -y install \
        software-properties-common \
        debconf-utils
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    apt-get -y install \
        oracle-java8-installer \
        tomcat7 \
        tomcat7-admin \
        tomcat7-user

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV CATALINA_HOME /usr/share/tomcat7
ENV CATALINA_BASE /var/lib/tomcat7
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH /usr/share/tomcat7/bin/catalina.sh

RUN mkdir -p ${CATALINA_BASE}/temp
RUN mkdir -p /etc/service/tomcat7
ADD tomcat7.sh /etc/service/tomcat7/run
RUN chmod +x /etc/service/tomcat7/run

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/work

VOLUME [ "/var/lib/tomcat7/webapps/" ]

EXPOSE 8080
CMD ["/sbin/my_init"]

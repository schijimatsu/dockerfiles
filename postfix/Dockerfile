FROM centos:centos6
MAINTAINER Chijimatsu@ATR Creative

RUN yum update -y
RUN yum groupinstall -y "Development Tools"
RUN yum install -y net-tools

RUN yum install -y postfix syslog cyrus-sasl cyrus-sasl-*

ADD main.cf /etc/postfix/main.cf
ADD smtpd.conf /etc/sasl2/smtpd.conf
ADD initialize.sh ./initialize.sh
RUN chmod 755 ./initialize.sh
RUN ["/bin/bash", "-c", "./initialize.sh"]
ADD run.sh ./run.sh
RUN chmod 755 ./run.sh

CMD ["/bin/bash", "-c", "./run.sh"]


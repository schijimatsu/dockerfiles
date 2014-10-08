FROM centos:centos6
MAINTAINER Chijimatsu@ATR Creative

RUN yum update -y
RUN yum groupinstall -y "Development Tools"
RUN yum install -y net-tools

RUN rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum install -y nginx


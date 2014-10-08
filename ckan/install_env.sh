#!/bin/bash

HOME=/home/atr

source $HOME/.bashrc
source $HOME/.bash_profile

cd $HOME/tmp
wget http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm
rpm -ivh pgdg-centos93-9.3-1.noarch.rpm
yum install -y postgresql93 postgresql93-devel
echo 'export PATH=$PATH:/usr/pgsql-9.3/bin' >> /home/atr/.bashrc

yum install -y java-1.7.0-openjdk*
cd $HOME/tmp
curl -O http://ftp.jaist.ac.jp/pub/apache/lucene/solr/4.10.0/solr-4.10.0.tgz
tar zxvf solr-4.10.0.tgz
mv solr-4.10.0/example /opt/solr
curl -o /etc/init.d/solr http://dev.eclipse.org/svnroot/rt/org.eclipse.jetty/jetty/trunk/jetty-distribution/src/main/resources/bin/jetty.sh
chmod +x /etc/init.d/solr
perl -pi -e 's/\/default\/jetty/\/sysconfig\/solr/g' /etc/init.d/solr
chkconfig solr on
useradd -r -d /opt/solr -M -c "Apache Solr" solr
chown -R solr:solr /opt/solr/


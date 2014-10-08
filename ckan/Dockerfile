FROM schijimatsu/python-2.7.6:centos6-0.0.0
MAINTAINER Chijimatsu@ATR Creative

USER root
ADD install_env.sh /home/atr/tmp/install_env.sh
WORKDIR /home/atr/tmp
RUN chmod 755 ./install_env.sh
RUN ["/bin/bash", "-c", "./install_env.sh"]
ADD solr /etc/sysconfig/solr
RUN chown solr:solr /etc/sysconfig/solr

USER atr
ENV HOME /home/atr

WORKDIR /home/atr
RUN git clone https://github.com/okfn/ckan.git
WORKDIR /home/atr/ckan
RUN git checkout -b 2.2 ckan-2.2
RUN echo '__import__("pkg_resources").declare_namespace(__name__)' >> ckanext/stats/__init__.py
RUN mv ckan/config/solr/schema.xml ckan/config/solr/schema-1.5.xml
RUN mv ckan/config/solr/schema-2.0.xml ckan/config/solr/schema.xml

USER root

WORKDIR /home/atr/ckan
RUN mv /opt/solr/solr/collection1/conf/schema.xml /opt/solr/solr/collection1/conf/schema-1.5.xml
RUN cp ckan/config/solr/schema.xml /opt/solr/solr/collection1/conf/schema.xml
RUN chown solr:solr /opt/solr/solr/collection1/conf/schema.xml
ADD in_virtualenv.sh /home/atr/ckan/in_virtualenv.sh
RUN ["/bin/bash", "-c", "chmod 755 /home/atr/ckan/in_virtualenv.sh"]

USER atr

WORKDIR /home/atr
RUN LD_LIBRARY_PATH=/usr/local/lib virtualenv env
WORKDIR /home/atr/ckan
RUN ["/bin/bash", "-c", "./in_virtualenv.sh"]
ADD initialize_ckan.sh /home/atr/ckan/initialize_ckan.sh

USER root
RUN chmod 755 /home/atr/ckan/initialize_ckan.sh
RUN yum install -y libxslt libxslt-devel
RUN yum install -y httpd httpd-devel
WORKDIR /home/atr/tmp
ADD install_mod_wsgi.sh /home/atr/tmp/install_mod_wsgi.sh
RUN chown atr:atr ./install_mod_wsgi.sh
RUN chmod 755 ./install_mod_wsgi.sh

USER atr
WORKDIR /home/atr/tmp
RUN ["/bin/bash", "-c", "./install_mod_wsgi.sh"]

USER root
WORKDIR /home/atr/tmp/mod_wsgi-3.5
RUN LD_LIBRARY_PATH=/usr/local/lib make install 
ADD apache.wsgi /home/atr/ckan/apache.wsgi
WORKDIR /home/atr/ckan
RUN chown atr:atr ./apache.wsgi
RUN chmod -R 755 ./apache.wsgi
RUN chmod 755 /home/atr
ADD ckan.conf /etc/httpd/conf.d/ckan.conf

USER atr
WORKDIR /home/atr
RUN git clone -b stable https://github.com/ckan/datapusher.git
WORKDIR /home/atr/datapusher
ADD initialize_datapusher.sh /home/atr/datapusher/initialize_datapusher.sh

USER root
WORKDIR /home/atr/datapusher
RUN chmod 755 ./initialize_datapusher.sh
ADD datapusher.conf /etc/httpd/conf.d/datapusher.conf
ADD datapusher.wsgi /home/atr/datapusher/deployment/datapusher.wsgi
ADD datapusher_settings.py /home/atr/datapusher/deployment/datapusher_settings.py
RUN chown atr:atr /home/atr/datapusher/deployment/datapusher.wsgi
RUN chown atr:atr /home/atr/datapusher/deployment/datapusher_settings.py
RUN mkdir /home/atr/datapusher/log
RUN touch /home/atr/datapusher/log/datapusher.log
RUN chown -R atr:atr /home/atr/datapusher/log
RUN chmod -R 777 /home/atr/datapusher/log

USER atr
WORKDIR /home/atr/datapusher
RUN ["/bin/bash", "-c", "./initialize_datapusher.sh"]

USER root
CMD ["/usr/sbin/sshd", "-D"]

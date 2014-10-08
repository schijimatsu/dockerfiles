FROM centos:centos6
MAINTAINER Chijimatsu@ATR Creative

RUN yum update -y
RUN yum groupinstall -y development
RUN yum install -y wget

WORKDIR /tmp
RUN wget http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm
RUN rpm -ivh pgdg-centos93-9.3-1.noarch.rpm
RUN yum install -y postgresql93 postgresql93-devel postgresql93-server
RUN service postgresql-9.3 initdb
RUN cat /var/lib/pgsql/9.3/data/pg_hba.conf | sed "s/peer/md5/" > /tmp/pg_hba.conf
RUN mv /tmp/pg_hba.conf /var/lib/pgsql/9.3/data/pg_hba.conf
RUN sed -i -e "78i local   all             postgres                                trust" /var/lib/pgsql/9.3/data/pg_hba.conf
RUN sed -i -e "80i host    all             all           172.17.0.0/12             md5" /var/lib/pgsql/9.3/data/pg_hba.conf
RUN cat /var/lib/pgsql/9.3/data/postgresql.conf | sed "s/# *\(listen_addresses *= *\)'localhost'/\1'*'/" > /tmp/postgresql.conf
RUN mv /tmp/postgresql.conf /var/lib/pgsql/9.3/data/postgresql.conf

ADD initialize_db.sh /tmp/initialize_db.sh
RUN chmod 755 /tmp/initialize_db.sh
RUN ["/bin/bash", "-c", "/tmp/initialize_db.sh"]

VOLUME ["/var/lib/pgsql"]
EXPOSE 5432

CMD ["/bin/su", "postgres", "-c", "/usr/pgsql-9.3/bin/postgres -D /var/lib/pgsql/9.3/data"]

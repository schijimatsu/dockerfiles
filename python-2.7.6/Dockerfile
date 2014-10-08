FROM centos:centos6
MAINTAINER ATR Creative

RUN yum update -y
RUN yum grouplist
RUN yum groupinstall -y development
RUN yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel
RUN yum install -y openssh-server
RUN mkdir /var/run/sshd
#RUN ssh-keygen -A
RUN ssh-keygen -t dsa -N "" -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
RUN sed -ie 's/^\(session \+required \+pam_loginuid.so\)/#\1/' /etc/pam.d/sshd

RUN yum install -y sudo wget

RUN useradd -m atr
RUN echo 'atr:atr' | chpasswd
RUN gpasswd -a atr wheel

RUN chmod 740 /etc/sudoers
RUN cat /etc/sudoers | sed "s/^\(# *\)\(%wheel.*\)$/\2/" > /etc/sudoers.new
RUN mv /etc/sudoers.new /etc/sudoers
RUN chmod 440 /etc/sudoers

USER atr
ENV HOME /home/atr
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' >> /home/atr/.bashrc

RUN mkdir -p /home/atr/tmp
WORKDIR /home/atr/tmp
RUN wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz
RUN xz -d Python-2.7.6.tar.xz
RUN tar xvf Python-2.7.6.tar
WORKDIR /home/atr/tmp/Python-2.7.6
RUN ./configure --prefix=/usr/local --enable-shared --with-threads
RUN make

USER root

WORKDIR /home/atr/tmp/Python-2.7.6
RUN make altinstall
RUN ln -s /usr/loca/bin/python2.7 /usr/local/bin/python

USER atr
ENV HOME /home/atr

RUN echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc
WORKDIR /home/atr/tmp
RUN wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
RUN tar zxvf setuptools-1.4.2.tar.gz

USER root

WORKDIR /home/atr/tmp/setuptools-1.4.2
RUN LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/python2.7 setup.py install
WORKDIR /home/atr/tmp
RUN curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/python2.7 -
RUN LD_LIBRARY_PATH=/usr/local/lib pip install virtualenv

EXPOSE 22 5000

CMD ["/usr/sbin/sshd", "-D"]


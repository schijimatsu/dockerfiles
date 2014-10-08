#!/bin/bash

HOME=/home/atr

source $HOME/.bashrc
source $HOME/.bash_profile

cd $HOME/tmp
wget https://github.com/GrahamDumpleton/mod_wsgi/archive/3.5.tar.gz
tar zxvf 3.5.tar.gz
cd mod_wsgi-3.5
LD_LIBRARY_PATH=/usr/local/lib ./configure --with-python=/usr/local/bin/python2.7
LD_LIBRARY_PATH=/usr/local/lib LD_RUN_PATH=/usr/local/lib make


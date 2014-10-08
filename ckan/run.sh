#!/bin/bash

HOME=/home/atr
CKAN_HOME=$HOME/ckan
cd $CKAN_HOME
source $HOME/.bashrc
source $HOME/.bash_profile
source $HOME/env/bin/activate

service solr start
sleep 15
gunicorn --paster production.ini --log-config=production.ini --timeout=120 --workers=2


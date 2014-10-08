#!/bin/bash

HOME=/home/atr
DATAPUSHER_HOME=$HOME/datapusher

source $HOME/.bashrc
source $HOME/.bash_profile
source $HOME/env/bin/activate

pip install -r requirements.txt
python setup.py develop


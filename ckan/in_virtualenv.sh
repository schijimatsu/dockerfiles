#!/bin/bash

source /home/atr/.bashrc
source /home/atr/.bash_profile
source /home/atr/env/bin/activate
sed -i -e "1i gunicorn==19.0.0" requirements.txt
pip install -r requirements.txt
python setup.py install


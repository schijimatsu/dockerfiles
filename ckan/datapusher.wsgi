import os
import sys
import hashlib

home = '/home/atr'
activate_this = os.path.join(home, '/env/bin/activate_this.py')
execfile(activate_this, dict(__file__=activate_this))

import ckanserviceprovider.web as web
import datapusher.jobs as jobs
os.environ['JOB_CONFIG'] = os.path.join(home, '/datapusher/deployment/datapusher_settings.py')

web.configure()
application = web.app

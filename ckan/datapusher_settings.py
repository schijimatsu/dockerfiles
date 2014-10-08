import uuid

DEBUG = False
TESTING = False
SECRET_KEY = str(uuid.uuid4())
USERNAME = str(uuid.uuid4())
PASSWORD = str(uuid.uuid4())

NAME = 'datapusher'

# database

SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/job_store.db'

# webserver host and port

HOST = '0.0.0.0'
PORT = 8800

# logging

FROM_EMAIL = 'admin@ckan.ddns.net'
ADMINS = ['schijimatsu@atr-c.jp']  # where to send emails

LOG_FILE = '/home/atr/datapusher/log/datapusher.log'
STDERR = True

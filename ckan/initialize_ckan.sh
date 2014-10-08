#!/bin/bash

CKAN_HOST=
CKAN_DOMAIN=ckan.ddns.net
CKAN_ADMIN=schijimatsu@atr-c.jp
SMTP_HOST=postfix
SMTP_USER=ckan
SMTP_PASSWORD=ckan
SMTP_MAILFROM="admin@"$CKAN_DOMAIN
HOME=/home/atr
CKAN_HOME=$HOME/ckan
PGPASSWORD=postgres

cd $CKAN_HOME
source $HOME/.bashrc
source $HOME/.bash_profile
source $HOME/env/bin/activate

sudo service solr start
sleep 10
paster make-config ckan development.ini
cat development.ini | sed "s/^\(sqlalchemy\.url = postgresql:\/\/\)\(.*\)$/\1ckan:ckan@postgres\/ckan/" | sed "s/^# *\(solr_url = .*\)$/\1/" > development.ini.new
mv development.ini.new development.ini
paster db init -c development.ini

PGPASSWORD=ckan createdb -U ckan -h postgres -O ckan datastore -E utf-8
echo "CREATE ROLE datastore WITH LOGIN CREATEDB PASSWORD 'datastore'" | PGPASSWORD=postgres psql -U postgres -h postgres
cat development.ini | sed "s/\(ckan\.plugins = .*\)/\1 datastore datapusher/" | sed "s/\# *\(ckan\.datastore\.write_url = postgresql:\/\/\).*/\1ckan:ckan@postgres\/datastore/" | sed "s/\# *\(ckan\.datastore\.read_url = postgresql:\/\/\).*/\1datastore:datastore@postgres\/datastore/" > development.ini.new
mv development.ini.new development.ini
cat ckanext/datastore/bin/set_permissions.sql | sed "s/{ckandb}/ckan/" | sed "s/{datastoredb}/datastore/" | sed "s/\({ckanuser}\|{writeuser}\)/ckan/" | sed "s/{readonlyuser}/datastore/" > set_permissions.sql.new
mv set_permissions.sql.new ckanext/datastore/bin/set_permissions.sql
cat ckanext/datastore/bin/set_permissions.sql | PGPASSWORD=postgres psql --dbname='datastore' -U postgres -h postgres

cat development.ini | sed "s/\# *\(ckan\.activity_streams_email_notifications.*\)/\1/" | sed "s/\(ckan\.site_url =\).*/\1 http:\/\/"$CKAN_HOST$CKAN_DOMAIN"/" | sed "s/\(\#\|\)\(smtp\.mail_from =\).*/\2 "$SMTP_MAILFROM"/" | sed "s/\(\#\|\) *\(email_to =\).*/\2 "$CKAN_ADMIN"/" | sed "s/\(\#\|\) *\(error_email_from =\).*/\2 "$SMTP_MAILFROM"/" | sed "s/\(\#\|\) *\(smtp\.server =\).*/\2 "$SMTP_HOST"/" | sed "s/\(\#\|\) *\(smtp\.starttls =\).*/\2 False/" | sed "s/\(\#\|\) *\(smtp\.user =\).*/\2 "$SMTP_USER"/" | sed "s/\(\#\|\) *\(smtp\.password =\).*/\2 "$SMTP_PASSWORD"/" | sed "s/\(\#\|\) *\(smtp\.mail_from =\).*/\2 "$SMTP_MAILFROM"/" > development.ini.new
sed -i -e "18i smtp_server = "$SMTP_HOST development.ini.new
mv development.ini.new development.ini

cat development.ini | sed "s/keys = console/keys = console, rotating/" | sed "s/handlers = console/handlers = console, rotating/" > development.ini.new
sed -i -e "186i [handler_rotating]" development.ini.new
sed -i -e "187i class = handlers.RotatingFileHandler" development.ini.new
sed -i -e "188i args = ('log/ckan.log', 'a', 5*1024*1024, 5)" development.ini.new
sed -i -e "189i level = NOTSET" development.ini.new
sed -i -e "190i formatter = generic" development.ini.new
sed -i -e "191i #" development.ini.new
mv development.ini.new development.ini

cat development.ini | sed "s/\(\#\|\) *\(ckan\.datapusher.url =.*\)/\2/" | sed "s/\(\#\|\) *\(ckan\.storage_path =\).*/\2 "$STORAGE_PATH"/" | sed "s/\(\#\|\) *\(ckan\.max_resource_size =\).*/\2 100/" | sed "s/\(\#\|\) *\(ckan\.max_image_size =\).*/\2 10/" > development.ini.new
sed -i -e "124i ofs.impl = pairtree" development.ini.new
mv development.ini.new development.ini

chown atr:atr development.ini

cp development.ini production.ini
chown atr:atr production.ini
mkdir log
touch ckan.log
chown -R atr:atr log
chmod -R 777 log


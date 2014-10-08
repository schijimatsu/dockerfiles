#!/bin/bash

DOMAIN=ckan.ddns.net
USER=ckan
PASSWORD=ckan

service saslauthd start
echo $PASSWORD | saslpasswd2 -p -u $DOMAIN -c $USER
chgrp postfix /etc/sasldb2


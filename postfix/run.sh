#!/bin/bash

service rsyslog start
service saslauthd start
service postfix start
tail -f /var/log/maillog

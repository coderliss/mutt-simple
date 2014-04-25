#!/bin/bash

LINE="*/2 * * * * /usr/bin/offlineimap -o > ~/.offlineimap/log 2>&1"
(crontab -u `whoami` -l; echo "$LINE" ) | crontab -u `whoami` -

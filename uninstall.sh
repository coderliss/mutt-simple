#!/bin/bash

echo -n "remove all mails and configuration files[y/n]:"
read YES_OR_NO
if [ "$YES_OR_NO" = "y" ] || [ "$YES_OR_NO" = "Y" ]; then
	rm -rf ~/.Mail ~/.mutt ~/.muttrc ~/.offlineimaprc ~/.offlineimap
	crontab -l | grep -v offlineimap | crontab -
	echo "uninstall OK"
fi


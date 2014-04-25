#!/bin/bash

cp -r $HOME/.muttrc .
sed -i '4,9d' .muttrc
sed -i '4i\set realname = "#REALNAME#"' .muttrc
sed -i '4i\set from = "#USERNAME#@gmail.com"' .muttrc
sed -i '4i\set smtp_pass = "#PASSWORD#"' .muttrc
sed -i '4i\set smtp_url = "smtp://#USERNAME#@gmail.com@smtp.gmail.com:587/"' .muttrc
sed -i '4i\set imap_pass = "#PASSWORD#"' .muttrc
sed -i '4i\set imap_user = "#USERNAME#@gmail.com"' .muttrc
sed -i '20,29d' .muttrc

cp -r $HOME/.mutt .
rm -rf .mutt/cache
rm -rf .mutt/.address.alias 

git add --all
if [[ -z $1 ]] ; then
	git commit -m "auto management"
else
	git commit -m "$1"
fi

git push origin master
echo "backup ok"

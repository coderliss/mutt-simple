#!/bin/bash
usage(){
	echo "Usage: $0 <username> <password> <real_name>"
	exit 1
	};
		 

if [ $# -ne 3 ] && [ $# -ne 0 ]; then
	usage
fi

echo "username( without @gmail.com):"
read USERNAME
echo "password(in plain):"
read -s PASSWD 
echo "real name:"
read REALNAME

sudo apt-get -y install mutt abook offlineimap

cp .muttrc muttrc.tmp
cp .offlineimaprc offlineimaprc.tmp 

cat .muttrc | python replace.py "#USERNAME#" "$USERNAME" >  muttrc.tmp.1
cat muttrc.tmp.1 | python replace.py "#PASSWORD#" "$PASSWD" >  muttrc.tmp.2
cat muttrc.tmp.2 | python replace.py "#REALNAME#" "$REALNAME" >  muttrc.tmp.3

cat .offlineimaprc | python replace.py "#USERNAME#" "$USERNAME" > offlineimaprc.tmp.1 
cat offlineimaprc.tmp.1 | python replace.py "#PASSWORD#" "$PASSWD" >  offlineimaprc.tmp.2 

mkdir -p ~/.Mail/INBOX/{new,cur,tmp}
mkdir -p ~/.mutt/cache/{headers,bodies}
mkdir -p ~/.offlineimap

echo "imap remote open mailbox or download mails local folder:"
echo "1. remote"
echo "2. local"
echo -n "which is your choice:"
read CHOICE

if [ $CHOICE -ne 1 ] && [ $CHOICE -ne 2 ]; then
	echo "invaild choice, default remote"
fi

if [ $CHOICE -eq 1 ]; then
	sed -i '20i\set maildir_header_cache_verify=no' muttrc.tmp.3
	sed -i '20i\set certificate_file=~/.mutt/certificates' muttrc.tmp.3
	sed -i '20i\set message_cachedir=~/.mutt/cache/bodies' muttrc.tmp.3
	sed -i '20i\set header_cache=~/.mutt/cache/headers' muttrc.tmp.3
	sed -i '20i\set record = "+[Gmail].Sent Mail"' muttrc.tmp.3
	sed -i '20i\set postpone = yes' muttrc.tmp.3
	sed -i '20i\set postponed="imaps://imap.gmail.com/[Gmail].Drafts"' muttrc.tmp.3
	sed -i '20i\# mailbox_remote' muttrc.tmp.3
	sed -i '20i\ ' muttrc.tmp.3 #empty line
else
	sed -i '20i\mailboxes "=INBOX"' muttrc.tmp.3
	sed -i '20i\set postponed="~/.Mail/[Gmail].Drafts"' muttrc.tmp.3
	sed -i '20i\set header_cache=~/.Mail/.hcache' muttrc.tmp.3
	sed -i '20i\set record="~/.Mail/[Gmail].Sent Mail"' muttrc.tmp.3
	sed -i '20i\set spoolfile="~/.Mail/INBOX"' muttrc.tmp.3
	sed -i '20i\set mbox_type=Maildir' muttrc.tmp.3
	sed -i '20i\set mbox="~/.Mail/INBOX"' muttrc.tmp.3
	sed -i '20i\set folder="~/.Mail"' muttrc.tmp.3
	sed -i '20i\# mailbox_local' muttrc.tmp.3
fi


cp -rf .mutt $HOME
cp -rf muttrc.tmp.3 $HOME/.muttrc
cp -rf offlineimaprc.tmp.2 $HOME/.offlineimaprc
rm *.tmp*

if [ $CHOICE -eq 2 ]; then
	CMD="./start_daemon.sh -n19 -c2 -p7 python2 /usr/bin/offlineimap >> ~/.offlineimap/log 2>&1 &"
	echo "three ways to start up:"
	echo "1. add offlineimap to crontab"
	echo "2. start offlineimap as daemon"
	echo "3. receive mail to local mailbox once"
	echo -n "which is your choice:"
	read CHOICE

	if [ $CHOICE -ne 1 ] && [ $CHOICE -ne 2 ] && [ $CHOICE -ne 3 ]; then
		echo "invaild choice, do noting, please start up manually"
	fi

	if [ $CHOICE -eq 1 ]; then
		./add_crontab.sh
	fi
	if [ $CHOICE -eq 2 ]; then
		$CMD
	fi
	if [ $CHOICE -eq 3 ]; then
		offlineimap -o
	fi
fi
echo "install ok"

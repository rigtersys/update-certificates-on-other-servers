#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi



function usage {
   echo
   echo "Usage: <domain> <servertype>"
   echo ""
   echo "Where <servertype> is one of the following:"
   echo "- dovecot"
   echo "- postfix"
   echo 
   echo "Example: $0 smtp.rigter.com postfix"
   echo "         $0 imap.rigter.com dovecot"
   echo
   exit

}


function get_certs {
	echo "- Creating new certificates on firewall for domain $1"
	ssh root@firewall1 "cd /opt/dehydrated; ./renew_single_certificate.sh $1"

	echo "Retrieving certificates from firewall"
	rsync -a -e "ssh root@firewall1" :/opt/dehydrated/certs/$1/*-*.pem /etc/letsencrypt/archive/$1/

	cd /etc/letsencrypt/live/$1
	echo "- Removing old symlinks"
	rm /etc/letsencrypt/live/$1/*
	echo "- Creating relevant symlinks for the new certificates"
	cd /etc/letsencrypt/live/$1
	for f in privkey fullchain chain cert; do
	    ls -1tr ../../archive/$1/$f-*.pem| tail -n 1 | while read i; do ln -s $i $f.pem; done;
        done;
}

if [[ "$1" == "" ]] || [[ "$2" == "" ]]; then
    usage
fi

if [[ "$2" =~ ^(dovecot|postfix)$ ]]; then 
   get_certs $1

   echo "Restarting service $2"
   sudo service $2 restart

else
    usage
fi

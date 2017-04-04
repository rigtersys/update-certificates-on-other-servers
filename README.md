# update-certificates-on-other-servers
Script to log into PFSense Generate Certificates and copy them to the correct destication for postfix apache or dovecot

This script logs into a PFSense Firfewall. Runs *dehydrated* ( https://github.com/lukas2511/dehydrated ) to generate new certs. 
Rsyncs them to the origin where you ran the script (in the /etc/letsencrypt/ directory that is part of the Let's Encrypt
certbot (i replaced this script with the certbot since the installation of HAProcy interfered with running the LE certbot
on the machines behind HAProxy (due to a catch all on ./well-known/acme-challenge/* *) ...

It replaced the symlinks live/*.pem and as i expect is everything up and running with new certs. Beware that you config your Apache
Postfix or Dovecot server to use the right scripts in /etc/letsencrypt/live/<domain>/*.pem....

If the script is failing in one way or the other let me know, and i'll see if i can try to fix it to suit all our needs!

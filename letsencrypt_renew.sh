#!/bin/bash

web_server='nginx'
exp_limit=30;
cert_file="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"

if [ ! -f $cert_file ]; then
	echo "[ERROR] certificate file not found for domain $DOMAIN."
fi

exp=$(date -d "`openssl x509 -in $cert_file -text -noout|grep "Not After"|cut -c 25-`" +%s)
datenow=$(date -d "now" +%s)
days_exp=$(echo \( $exp - $datenow \) / 86400 |bc)

echo "Checking expiration date for $DOMAIN..."

if [ "$days_exp" -gt "$exp_limit" ] ; then
	echo "The certificate is up to date, no need for renewal ($days_exp days left)."
	exit 0;
else
	echo "The certificate for $DOMAIN is about to expire soon. Starting webroot renewal script..."
  /opt/letsencrypt/letsencrypt-auto certonly -a webroot --non-interactive --agree-tos --email $EMAIL --renew-by-default --webroot-path=/usr/share/nginx/html -d $DOMAIN

  echo "Reloading $web_server"
	/usr/sbin/service $web_server reload
	echo "Renewal process finished for domain $DOMAIN"
	exit 0;
fi

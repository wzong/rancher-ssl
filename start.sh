if [ ! -d /etc/letsencrypt/live/$DOMAIN ]; then
  /opt/letsencrypt/letsencrypt-auto certonly --non-interactive --agree-tos --email $EMAIL --standalone -d $DOMAIN
fi

sed "s/<DOMAIN>/$DOMAIN/" ./nginx.conf > /etc/nginx/nginx.conf
nginx -g "daemon off; error_log /dev/stderr notice;"

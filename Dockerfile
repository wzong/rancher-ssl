FROM nginx

RUN apt-get update \
    && apt-get install -y git bc cron \
    && rm -rf /var/lib/apt/lists/*

# get letsencrypt client for setup of certificate
# will be replaced by native package when it is available.
RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

RUN mkdir -p /usr/src
WORKDIR /usr/src
COPY . /usr/src

# setup certificate renewal script.
RUN chmod +x ./letsencrypt_renew.sh \
    && touch /var/log/letsencrypt_renew.log \
    && ln -sf /dev/stdout /var/log/letsencrypt_renew.log \
    && chmod +x ./crontab.sh \
    && crontab -u root crontab.sh \
    && chmod +x ./start.sh

CMD ["/bin/sh", "-c", "./start.sh"]

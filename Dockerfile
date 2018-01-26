FROM jubicoy/nginx:full-ubuntu
MAINTAINER Matti Rita-Kasari "matti.rita-kasari@jubic.fi"

RUN apt-get update && \
  apt-get install -y language-pack-en-base && \
  export LC_ALL=en_US.UTF-8 && \
  export LANG=en_US.UTF-8 && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:ondrej/php

RUN apt-get update && apt-get install -y supervisor gettext wget \
  libnss-wrapper php7.1 && \
  apt-get upgrade -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create some needed directories
RUN mkdir -p /workdir/sv-child-logs

# Add configuration files
ADD config/default.conf /etc/nginx/conf.d/default.conf
ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD config/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
ADD config/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD passwd.template /workdir/passwd.template

# Add entrypoint script
ADD entrypoint.sh /workdir/entrypoint.sh

# Fix permissions issues
RUN chown -R 104:0 /workdir && chown -R 104:0 /var/www
RUN chmod -R g+rw /workdir && chmod -R a+x /workdir && chmod -R g+rw /var/www

WORKDIR /workdir

ENTRYPOINT ["/workdir/entrypoint.sh"]

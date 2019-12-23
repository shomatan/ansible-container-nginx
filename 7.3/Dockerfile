FROM shomatan/php-fpm:7.3.5-alpine

LABEL maintainer "Shoma Nishitateno <shoma416@gmail.com>"

# cron
USER root

RUN set -xe \
  && echo '* * * * * php /var/www/html/artisan schedule:run >> /dev/null 2>&1' > /var/spool/cron/crontabs/root \
  && chmod 644 /var/spool/cron/crontabs/root

USER www

COPY files/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/local/sbin/php-fpm", "--nodaemonize", "--fpm-config", "/usr/local/etc/php-fpm.conf", "--allow-to-run-as-root"]
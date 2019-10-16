#!/bin/sh
set +e

echo "** Preparing php-fpm container for Laravel"

cat > .env <<EOF
APP_ENV=${APP_ENV}
APP_DEBUG=${APP_DEBUG}
APP_KEY=
DB_HOST=${DB_HOST}
DB_DATABASE=${DB_NAME}
DB_USERNAME=${DB_USER}
DB_PASSWORD=${DB_PASS}
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync
MAIL_DRIVER=smtp
MAIL_HOST=mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
EOF

php artisan key:generate

echo "** Waiting for MySQL"
until php artisan migrate --force; do
  >&2 echo "**** MySQL is unavailable - sleeping"
  sleep 1
done

echo "** Database seeding"
php artisan db:seed --force

chmod 777 -R storage

/usr/sbin/crond

echo "########################################################"

echo "** Executing php-fpm"

echo "*** with arguments: $@"

exec /usr/local/bin/docker-entrypoint.sh "$@"
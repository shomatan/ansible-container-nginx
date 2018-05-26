FROM shomatan/php-fpm:7.1-alpine

LABEL maintainer "Shoma Nishitateno <shoma416@gmail.com>"

# Environment variable
ARG MYSQL_VERSION=10.1.22-r0
ARG APCU_VERSION=5.1.8
ARG APCU_BC_VERSION=1.0.3

RUN set -ex \
    && apk update \
    && apk add --no-cache \
        libbz2 \
        gd \
        gettext \
        libmcrypt \
        libxslt \
    && apk add --no-cache --virtual .build-php \
        $PHPIZE_DEPS \
        mariadb=$MYSQL_VERSION \
        mariadb-dev=$MYSQL_VERSION \
        gd-dev \
        jpeg-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        zlib-dev \
        freetype-dev \
        bzip2-dev \
        libexif-dev \
        xmlrpc-c-dev \
        pcre-dev \
        gettext-dev \
        libmcrypt-dev \
        libxslt-dev \
    && pecl install apcu-$APCU_VERSION \
    && docker-php-ext-enable apcu \
    && pecl install apcu_bc-$APCU_BC_VERSION \
    && docker-php-ext-enable apc \
    && docker-php-ext-install \
        mysqli \
        opcache \
        gd \
        bz2 \
        pdo pdo_mysql \
        bcmath exif gettext mcrypt pcntl \
        soap sockets sysvsem sysvshm xmlrpc xsl zip \
    && apk del .build-php \
    && rm -f /usr/local/etc/php/conf.d/docker-php-ext-apc.ini \
    && rm -f /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
    && rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && mkdir -p /etc/php.d/

COPY files/*.ini /usr/local/etc/php/conf.d/
COPY files/opcache*.blacklist /etc/php.d/

# Cron
RUN echo '* * * * * php /var/www/html/artisan schedule:run >> /dev/null 2>&1' > /var/spool/cron/crontabs/root

# Composer
RUN set -ex \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin \
    && mv /usr/local/bin/composer.phar /usr/local/bin/composer
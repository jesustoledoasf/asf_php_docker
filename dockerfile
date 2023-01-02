# FROM php:5.4-apache
FROM php:5.6-apache
RUN apt-get update && apt-get install -y --force-yes \
        libcurl4-openssl-dev \
        libedit-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        zlib1g-dev \
        freetds-dev \
        freetds-bin \
        freetds-common \
        libdbd-freetds \
        libsybdb5 \
        libqt4-sql-tds \
        libqt5sql5-tds \
        libqxmlrpc-dev \
      && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so \
      && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
      && docker-php-ext-install   mssql \
      && docker-php-ext-configure mssql \
      && chmod 755 /var/www/html -R \
      && chown www-data:www-data /var/www/html

RUN a2enmod rewrite
RUN a2enmod headers

COPY ./settings/my-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./settings/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./docker/php/conf.d/error_reporting.ini /usr/local/etc/php/conf.d/error_reporting.ini
 RUN /etc/init.d/apache2 restart
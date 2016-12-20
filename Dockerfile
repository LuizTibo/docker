FROM php:7-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
		libpq-dev \
		libssl-dev \
		git \
		zip \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pgsql pdo pdo_pgsql \
    && pecl install mongodb \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/ext-mongodb.ini
    #&& docker-php-ext-enable mongodb

RUN cd /usr/local/bin/ && curl -sS https://getcomposer.org/installer | php && mv composer.phar composer

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

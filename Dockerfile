FROM php:7.2.12-apache-stretch
RUN apt-get update && apt-get install -y libc-client-dev libfreetype6-dev libmcrypt-dev libpng-dev \
      libjpeg-dev libldap2-dev zlib1g-dev libkrb5-dev libtidy-dev \
      ssl-cert \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/  --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli pdo pdo_mysql opcache zip iconv tidy \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap
RUN if [ "$http_proxy" != "" ]; then pear config-set http_proxy $http_proxy; fi \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
    && a2enmod rewrite
RUN a2ensite default-ssl &&\
    a2enmod ssl

RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
		echo 'memory_limit=256M'; \
		echo 'upload_max_filesize=128M'; \
		echo 'post_max_size=128M'; \
		echo 'max_execution_time=120'; \
        echo 'max_input_vars=10000'; \
        echo 'date.timezone=UTC'; \
	} > /usr/local/etc/php/conf.d/uploads.ini

VOLUME ["/var/www/html/plugins"]
VOLUME ["/var/www/html/upload"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY config.php /var/www/html/application/config/config.php
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
ENV NEW_SERVER_NAME default
ENV ENABLE_SSL off

ENV DOWNLOAD_URL https://github.com/LimeSurvey/LimeSurvey/archive/3.15.3+181108.tar.gz
RUN set -x \
	&& curl -SL "$DOWNLOAD_URL" -o /tmp/lime.tar.gz \
    && tar xf /tmp/lime.tar.gz --strip-components=1 -C /var/www/html \
    && rm /tmp/lime.tar.gz \
    && chown -R www-data:www-data /var/www/html

EXPOSE 80 443
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]

FROM php:7.1-fpm

COPY . /var/www/microjobs

COPY check_db.sh /entrypoint/

RUN ["chmod", "+x", "/entrypoint/check_db.sh"]

WORKDIR /var/www/microjobs

RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev mysql-client vim iputils-ping libpng-dev git unzip && docker-php-ext-install gd zip pdo pdo_mysql 

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&& composer install

RUN chown -R www-data:www-data /var/www/microjobs

ENTRYPOINT ["sh", "/entrypoint/check_db.sh"]





FROM php:8.4-apache

ARG HOST_UID=1000
ARG HOST_GID=1000

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# Install dependencies
RUN apt-get update
RUN apt-get install -y default-mysql-client
RUN apt-get install -y graphicsmagick
RUN apt-get install -y libfreetype*
RUN apt-get install -y libicu-dev
RUN apt-get install -y libjpeg62-turbo-dev
RUN apt-get install -y libonig-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libzip-dev
RUN apt-get install -y nano
RUN apt-get install -y unzip
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y locales
RUN apt-get install -y locales-all

# Clean up apt cache
RUN apt-get clean

# Set locales
RUN locale-gen de_DE.UTF-8
RUN locale-gen it_IT.UTF-8
RUN locale-gen en_GB.UTF-8
RUN update-locale LANG=de_DE.UTF-8

ENV LANG de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8
ENV LANGUAGE de_DE.UTF-8

# Remove leftover apt cache
RUN rm -rf /var/lib/apt/lists/*

# Install GD library
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install PHP extensions one by one
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install intl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip
RUN docker-php-ext-install exif

RUN chown -R www-data:www-data /var/www/html
USER www-data

# Enable Apache rewrite module
RUN a2enmod rewrite

# Expose ports for Apache
EXPOSE 80
EXPOSE 443

# Set the working directory
WORKDIR /var/www/html

# Start Apache
CMD ["apache2-foreground"]

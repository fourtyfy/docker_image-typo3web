FROM php:8.3-apache

# Set the working directory
WORKDIR /var/www/html

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
RUN locale-gen de_DE.UTF-8
RUN locale-gen it_IT.UTF-8
RUN locale-gen en_GB.UTF-8
RUN update-locale LANG=de_DE.UTF-8

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install GD library
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install extensions one by one to manage memory
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install intl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache rewrite module
RUN a2enmod rewrite

# Expose port
EXPOSE 80
EXPOSE 443

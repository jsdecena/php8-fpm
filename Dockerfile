FROM php:8.1.3-fpm
LABEL Maintainer="Jeff Simons Decena <jeff.decena@yahoo.com>" \
      Description="Minimal PHP 8 with FPM"

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    vim \
    unzip \
    git \
    curl \
    postgresql \ 
    postgresql-contrib \
    libpq-dev \
    libonig-dev \
    zlib1g-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libssh2-1-dev \
    libssh2-1 \
    && pecl install ssh2-1.3.1 \
    && docker-php-ext-enable ssh2

RUN apt-get upgrade -y && apt autoremove -y

RUN pecl config-set php_ini /etc/php.ini

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql gd zip mbstring exif pcntl gd bcmath sockets

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

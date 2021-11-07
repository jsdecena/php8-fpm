FROM php:8.0-fpm
LABEL Maintainer="Jeff Simons Decena <jeff.decena@yahoo.com>" \
      Description="Minimal PHP 8.0 with FPM"

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
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
    libssh2-1 \
    gcc make libssh2-1-dev \
    zlib1g-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev

RUN pecl config-set php_ini /etc/php.ini

RUN curl http://pecl.php.net/get/ssh2-1.2.tgz -o ssh2.tgz && \
    pecl install ssh2 ssh2.tgz && \
    docker-php-ext-enable ssh2 && \
    rm -rf ssh2.tgz

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql gd zip mbstring exif pcntl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install bcmath sockets

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

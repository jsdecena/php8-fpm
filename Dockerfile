FROM php:8.4-fpm
LABEL Maintainer="Jeff Simons Decena <jeff.decena@yahoo.com>" \
      Description="Minimal PHP 8 with FPM"

# Install dependencies (dev packages removed after compile — avoids libpng-dev in final image)
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libjpeg-dev \
    libfreetype-dev \
    libwebp-dev \
    libxrender1 \
    libfontconfig1 \
    libx11-6 \
    libxext6 \
    fontconfig \
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
    libicu-dev \
    && { [ -f "${PHP_INI_DIR}/php.ini" ] || cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"; } \
    && pecl config-set php_ini "${PHP_INI_DIR}/php.ini" \
    && pecl install ssh2-1.3.1 \
    && docker-php-ext-enable ssh2

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" pdo pdo_mysql pdo_pgsql gd zip mbstring exif pcntl bcmath sockets intl mysqli \
    && pecl install redis \
    && docker-php-ext-enable redis

# Drop *-dev and compilers; keep runtime libs required by php extensions (clears libpng-dev finding)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpng16-16t64 \
        libfreetype6 \
        libjpeg62-turbo \
        libwebp7 \
        libsharpyuv0 \
        libpq5 \
        libzip5 \
        libicu76 \
    && apt-mark manual \
        libpng16-16t64 \
        libfreetype6 \
        libjpeg62-turbo \
        libwebp7 \
        libsharpyuv0 \
        libpq5 \
        libzip5 \
        libicu76 \
    && apt-get purge -y \
        build-essential \
        pkg-config \
        libpng-dev \
        libjpeg62-turbo-dev \
        libjpeg-dev \
        libfreetype-dev \
        libwebp-dev \
        libpq-dev \
        libonig-dev \
        zlib1g-dev \
        libzip-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libicu-dev \
        libssh2-1-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Default non-root user (PHP-FPM pool already uses www-data)
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

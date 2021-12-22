# PHP 8-fpm

[![Snyk Container](https://github.com/jsdecena/php80-fpm/actions/workflows/snyk-container-analysis.yml/badge.svg)](https://github.com/jsdecena/php80-fpm/actions/workflows/snyk-container-analysis.yml)

Minimal PHP 8 with FPM Docker Image

## Docker build commands

```
docker build -t jsdecena/php8-fpm:latest .
docker build -t jsdecena/php8-fpm:8.1.0 .
docker build -t jsdecena/php8-fpm:8.0.13 .
```

## Push to docker hub

```
docker login -u <username> -p <token>
docker push jsdecena/php8-fpm:<tag>
```
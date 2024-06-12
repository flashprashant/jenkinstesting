FROM php:8.2-cli as base

RUN apt-get update && apt-get install -y libzip-dev wget unzip git
RUN docker-php-ext-install zip sockets

RUN groupadd -r app -g 1000 && \
    useradd -u 1000 -r -g app -m -d /home/app -s /bin/bash -c "App user" app

ENV COMPOSER_HOME /.composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
RUN mkdir -p $COMPOSER_HOME && \
    chown app:app $COMPOSER_HOME

ENV APP_DIR /app

RUN mkdir -p $APP_DIR && \
    chown app:app $APP_DIR

WORKDIR $APP_DIR

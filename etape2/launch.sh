#!/bin/bash

docker rm -f http script data 2>/dev/null || true
docker network rm tp3 2>/dev/null || true

docker network create tp3
docker build -t tp3-php-mysqli ./php

docker container run -d \
  --name data \
  --network tp3 \
  -e MARIADB_RANDOM_ROOT_PASSWORD=1 \
  -v "$(pwd)/sql":/docker-entrypoint-initdb.d \
  mariadb

docker container run -d \
  --name script \
  --network tp3 \
  -v "$(pwd)/src":/app \
  tp3-php-mysqli

docker container run -d \
  --name http \
  --network tp3 \
  -p 8080:80 \
  -v "$(pwd)/src":/app \
  -v "$(pwd)/config/default.conf":/etc/nginx/conf.d/default.conf \
  nginx

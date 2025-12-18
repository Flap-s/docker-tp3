#!/bin/bash

docker rm -f script 2>/dev/null || true
docker rm -f http 2>/dev/null || true
docker network rm tp3 2>/dev/null || true
docker network create tp3

docker container run -d \
  --name script \
  --network tp3 \
  -v "$(pwd)/src":/app \
  php:8.2-fpm

docker container run -d \
  --name http \
  --network tp3 \
  -p 8080:80 \
  -v "$(pwd)/src":/app \
  -v "$(pwd)/config/default.conf":/etc/nginx/conf.d/default.conf \
  nginx

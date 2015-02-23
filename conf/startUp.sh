#!/usr/bin/env bash

echo "running docker image script"

nginx
php5-fpm -c /etc/php5/fpm


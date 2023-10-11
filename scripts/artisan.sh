#!/usr/bin/env bash

clear;
SCRIPT_LOCATION="$(dirname "$0")"
source $SCRIPT_LOCATION/vars.sh
docker compose -p ${DOCKER_PROJECT_NAME} exec -u drs app php artisan $@

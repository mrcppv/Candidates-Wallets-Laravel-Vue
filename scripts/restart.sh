#!/usr/bin/env bash

clear;
SCRIPT_LOCATION="$(dirname "$0")"
source $SCRIPT_LOCATION/vars.sh

docker compose -p ${DOCKER_PROJECT_NAME} down
docker compose -p ${DOCKER_PROJECT_NAME} up -d

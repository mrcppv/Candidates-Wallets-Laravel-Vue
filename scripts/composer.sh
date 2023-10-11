#!/usr/bin/env bash

clear;
SCRIPT_LOCATION="$(dirname "$0")"
source $SCRIPT_LOCATION/vars.sh
if tty -s; then
    echo 'Running composer in interactive mode.'
    docker compose -p ${DOCKER_PROJECT_NAME} exec -u drs app composer $@
else
    echo 'Running composer in non-interactive mode.'
    docker compose -p ${DOCKER_PROJECT_NAME} exec -u drs -T app composer $@
fi

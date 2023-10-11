#!/usr/bin/env bash

clear;
SCRIPT_LOCATION="$(dirname "$0")"
source $SCRIPT_LOCATION/vars.sh
docker compose -p ${DOCKER_PROJECT_NAME} exec $@

## E.g.: Dump database to a file:
# docker compose -p ${DOCKER_PROJECT_NAME} exec pgsql pg_dumpall -U digital_recording_system > dump.sql

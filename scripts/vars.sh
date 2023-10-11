#!/usr/bin/env bash

GIT_BRANCH=$(git symbolic-ref --short -q HEAD)
DOCKER_PROJECT_NAME="drs-ca-${GIT_BRANCH}"

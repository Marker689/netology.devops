#!/bin/bash

CONF_FILE=/etc/gitlab-runner/config.toml
echo -e "Starting registration script...\n"
if [ ! -s "${CONF_FILE}" ]; then
    gitlab-runner register --non-interactive \
    --url "http://gitlab.kharitonov.su" \
    --registration-token="GR1348941pCwuMsJd3aW9Pnufd6F3" \
    --description="runner dind" \
    --executor="docker" \
    --docker-image="ubuntu:latest" \
    --docker-volumes=/var/run/docker.sock:/var/run/docker.sock \
    --locked=false
else
    echo -e "Ignoring registration : config.toml file not empty (already registered)."
fi
echo -e "End registration script. \n"

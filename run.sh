#!/bin/bash
export ENV_GITHUB_USER=${ghuser}
export ENV_GITHUB_USER=${ghpass}
export ENV_GITHUB_USER=${ghrepo}

# Startup container(s)
cat docker-compose.yml | envsubst | docker-compose -H $DOCKER_HOST_HOST -f - up -d
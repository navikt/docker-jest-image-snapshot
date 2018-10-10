#!/bin/bash
# Denne filen må ha LF som line separator.

# Stop scriptet om en kommando feiler
set -e

# Usage string
usage="Script som bygger prosjektet

Bruk:
./$(basename "$0") OPTIONS

Gyldige OPTIONS:
    -h  | --help        - printer denne hjelpeteksten
"

# Les versjonsnummer fra VERSION fil
VERSJON=`cat "${BASH_SOURCE%/*}/VERSION"`

# Default verdier
IMAGE_NAME="soknad-docker-jest-image-snapshot"
DOCKER_REGISTRY="repo.adeo.no:5443"
DOCKER_REPOSITORY="soknad"
TAG="${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/${IMAGE_NAME}:$VERSJON"


# Hent ut argumenter
for arg in "$@"
do
case $arg in
    -h|--help)
    echo "$usage" >&2
    exit 1
    ;;
    *) # ukjent argument
    printf "Ukjent argument: %s\n" "$1" >&2
    echo ""
    echo "$usage" >&2
    exit 1
    ;;
esac
done


function build_container() {
    docker build \
        --tag ${TAG} \
        --build-arg NPM_TOKEN=${NPM_AUTH} \
        .
}

function already_published() {
    RESULT=`docker search --limit 100 "$TAG" | grep -o "$TAG"`
    if [[ ${RESULT} != ${VERSJON} ]]; then
        false
    else
        true
    fi
}

function on_master_branch() {
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$BRANCH" == "master" ]]; then
        true
    else
        false
    fi
}

function publish_container() {
    docker push ${TAG}
}

build_container

if already_published; then
    echo "Denne versjonen er allerede publisert. Oppdater VERSION filen for å publisere en ny versjon"
else
    if on_master_branch; then
        echo "Publiserer nytt docker image"
        publish_container
    else
        echo "Ikke på master branch. Venter med å publisere"
    fi
fi

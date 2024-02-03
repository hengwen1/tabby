#!/bin/bash
#
# Build latest:
# ./build_all.sh
#
# Build and push version X.Y.Z:
# ./build_all.sh X.Y.Z 1

set -e

# allow user to run this script from anywhere
# from https://stackoverflow.com/a/246128
# one-liner which will give you the full directory name
# of the script no matter where it is being called from
unset CDPATH
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ROOT_DIR=$DIR
cd $ROOT_DIR

VERSION=${1:-latest}
PUSH=${2:-0}
IMAGE=hcaoextr/tabbyml-jetson

build()
{
    DOCKERFILE=$1
    BUILD_ARGS=${3:-}

    LATEST=$IMAGE:latest
    TAGGED=$IMAGE:$VERSION
    docker build --pull $BUILD_ARGS -t $LATEST -f $DOCKERFILE .
    if [ $PUSH -eq 1 ]; then
        docker push $LATEST
    fi
    if [ "$TAGGED" != "$LATEST" ]; then
        docker tag $LATEST $TAGGED
        if [ $PUSH -eq 1 ]; then
            docker push $TAGGED
        fi
    fi
}

build Dockerfile.jetson

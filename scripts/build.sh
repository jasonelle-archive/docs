#!/usr/bin/env sh

docker run --rm -v $PWD/src:/src rocker/verse /bin/sh -c 'cd /src && ./build.sh'
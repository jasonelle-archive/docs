#!/bin/sh

set -e

[ "${TRAVIS_BRANCH}" != "develop" ] && echo "Commmit not on develop branch" && exit -1

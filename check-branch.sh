#!/bin/sh

set -e

if [ "${TRAVIS_BRANCH}" != "develop" ]
then
  echo "Commmit not on develop branch"
  exit -1
fi

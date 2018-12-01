#!/bin/sh

set -e

[ -z "${GH_TOKEN}" ] && echo "Github Token Not Found" && exit -1
[ "${TRAVIS_BRANCH}" != "develop" ] && echo "Commmit not on develop branch" && exit -1

BOOK_DIR=$(pwd)/_book
rm -rf ~/_book
mkdir ~/_book && cd ~/_book
git clone -b master https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git .
ls | grep -v ^bookdown[.].* | xargs rm -rf
git ls-files --deleted -z | xargs -0 git rm
cp -r ${BOOK_DIR}/* ./
git add --all *
git commit -m "deployed docs (travis build ${TRAVIS_BUILD_NUMBER})"
git push -q -f origin master

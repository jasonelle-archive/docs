#!/bin/sh

set -e

BOOK_DIR=${PWD}/_book
cp -r ${BOOK_DIR}/* ./
rm -rf ${BOOK_DIR}

git checkout master
git add --all *
git commit -m "deployed docs (travis build ${TRAVIS_BUILD_NUMBER})"
git push -q -f origin master

echo "Deployed"

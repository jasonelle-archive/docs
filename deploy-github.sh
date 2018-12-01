#!/bin/sh

set -e

BOOK_DIR=$(pwd)
mkdir ~/deploy
cd ~/deploy

git clone -b master https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git .

cp -r ${BOOK_DIR}/* ./
cp -r ./_book/* ./
rm -rf ./_book
rm -rf *.Rmd
rm -rf *.bib
rm -rf *.Rproj
rm -rf *.tex
rm -rf *.yml
rm -rf *.editorconfig
rm -rf *.gitattributes
rm -rf *.Rbuildignore
rm -rf .Rproj.user
rm -rf Rhistory
rm -rf *.sh
rm -rf DESCRIPTION

git add --all *
git commit -m "deployed docs (travis build ${TRAVIS_BUILD_NUMBER})"
git push -q -f origin master

echo "Deployed"

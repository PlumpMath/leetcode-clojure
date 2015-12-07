#!/usr/bin/env bash

# exit with nonzero exit code if anything fails
set -e

# Local variables
OUT=".gh-pages"
ID=$(git rev-parse --short HEAD)
DATE=$(date)

# clear and re-create the out directory
rm -rf $OUT || exit 0;
git clone "https://${GH_TOKEN}@${GH_REF}" $OUT

# checkout to gh-pages
git checkout -b gh-pages origin/gh-pages

# remove all data in $OUT
(cd $OUT; git rm -rf *)

# Copy all prebuild files
cp docs/uberdoc.html $OUT/index.html

# go to the out directory and create a *new* Git repo
cd $OUT
git init

# inside this git repo we'll pretend to be a new user
git config user.name "Travis CI"
git config user.email "coldnew.tw@gmail.com"

# The first and only commit to this new Git repo contains all the
# files present with the commit message "Deploy to GitHub Pages".
git add .
git commit -m "deploy commit $ID to GitHub Pages: $DATE"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
#git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages
#> /dev/null 2>&1
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" gh-pages/gh-pages
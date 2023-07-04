#!/bin/bash

bundle exec jekyll build
( cd _site || exit
git add -A
git commit --amend --no-edit
git push --force-with-lease
)

#!/bin/bash
# Sync remote pending branches locally, and prune merged branches.
set -e

git fetch origin --prune
PREVBRANCH="$(git rev-parse --abbrev-ref HEAD)"
git branch --merged | tr -d ' ' | grep ^pending- | xargs -trn1 git branch -d
git branch --list -r 'origin/pending-*' --format='%(refname:lstrip=3)' | xargs -trn1 git checkout
git checkout "$PREVBRANCH"

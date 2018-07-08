#!/bin/bash
# List pending branches that we have, but that are not in NEW.
# You might find it also useful to pipe the output of this into filter-in-debian.sh
set -e

git fetch origin --prune
comm -13 \
 <(curl -s https://ftp-master.debian.org/new.html | \
   grep '<td class="package">rust-' | \
   sed -nre 's/.*\brust-([-A-Za-z0-9]+)\b.*/\1/gp' | \
   sort) \
 <(git branch --list -r 'origin/pending-*' --format='%(refname)' | \
   sed -e 's,refs/remotes/origin/pending-,,g' | \
   sort)

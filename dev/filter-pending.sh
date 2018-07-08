#!/bin/bash
# Filter list of crates by whether they're pending an upload by this team.
set -e

git fetch origin --prune
while read crate; do
	pkg="${crate//_/-}"
	if git show-ref --quiet --verify "refs/remotes/origin/pending-$pkg"; then
		echo "$crate 1"
	else
		echo "$crate 0"
	fi
done

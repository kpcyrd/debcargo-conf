#!/bin/bash
# Filter list of crates by whether all their build-deps are in Debian
# Use like, e.g. `dev/list-unreleased.sh | dev/filter-builddeps-ok.sh`
set -e

echo >&2 "redirecting all other output e.g. from debcargo to stderr"
while read crate ver; do
	./repackage.sh "$crate" $ver >&2
	if ( cd build && SOURCEONLY=1 ./build.sh "$crate" $ver >&2 ); then
		ok=1
	else
		ok=0
	fi
	echo "$crate $ver $ok"
done

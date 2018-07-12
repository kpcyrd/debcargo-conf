#!/bin/bash
# List packages that are UNRELEASED and also not pending.
set -e

git grep -l UNRELEASED-FIXME-AUTOGENERATED-DEBCARGO -- src/*/debian/changelog | cut -d/ -f2 | \
"$(dirname "$0")/filter-pending.sh" | \
grep " 0$" | \
cut '-d ' -f1 | \
while read crate; do
	pkg="${crate//_/-}"
	head -n1 src/$pkg/debian/changelog
done
#!/bin/bash
# Filter list of crates by whether all their build-deps are in Debian
# Use like, e.g. `dev/list-unreleased.sh | dev/filter-builddeps-ok.sh`
set -e

shouldbuild() {
	local dst="$1"
	local src="$2"
	test ! -e "$dst" -o "$src" -nt "$dst"
}

echo >&2 "redirecting all other output e.g. from debcargo to stderr"
while read crate ver; do
	pkgname="${crate//_/-}${ver:+-$ver}"
	if shouldbuild "build/$pkgname/debian/changelog" "src/$pkgname/debian/changelog"; then
		realver="$(sed -nre "s/.*Package .* (.*) from crates.io.*/\1/gp" src/$pkg/debian/changelog | head -n1)"
		REALVER="$realver" ./update.sh "$crate" $ver >&2 # TODO: no-overlay-write-back
	fi
	if ( cd build && SOURCEONLY=1 ./build.sh "$crate" $ver >&2 ); then
		ok=1
	else
		ok=0
	fi
	echo "$crate $ver $ok"
done

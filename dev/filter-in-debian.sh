#!/bin/bash
# Filter list of crates by whether they're not in Debian.
# You need to have an up-to-date APT cache for Debian unstable.

while read crate; do
	pkg="${crate//_/-}"
	numpkg="$(apt-cache showsrc --only-source rust-"$pkg" 2>/dev/null | grep Package: | wc -l)"
	echo "$crate $numpkg"
done

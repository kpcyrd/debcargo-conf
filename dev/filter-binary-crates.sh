#!/bin/bash
# Filter list of crates by whether they're a binary crate.

while read crate; do
	if debcargo extract "$crate" >/dev/null 2>/dev/null; then
		dir="$(ls -1d "rust-${crate//_/-}"-*)"
		bin="$(ls -1 "$dir/src/{main.rs,bin/*.rs}" 2>/dev/null | wc -l)"
		if [ "$bin" -gt 0 ] || grep -q '\[\[bin\]\]' "$dir/Cargo.toml"; then
			echo "$crate"
		fi
		rm -rf "$dir"
	fi
done

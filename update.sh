#!/bin/sh

. ./vars.sh.frag

if [ ! -d "$PKGDIR/debian" ]; then
	mkdir -p "$PKGDIR/debian"
	sed -e 's/^#overlay =/overlay =/' -e '/^#/d' "$DEBCARGO_GIT/debcargo.toml.example" > "$PKGCFG"
	touch "$PKGDIR/debian/copyright"
	git add "$PKGDIR"
fi

rm -rf "$BUILDDIR" && mkdir -p "$(dirname $BUILDDIR)"
$DEBCARGO package --config "$PKGCFG" --directory "$BUILDDIR" "$PKG"

if ! git diff -q -- "$PKGDIR_REL"; then
	read -p "Update wrote some changes to $PKGDIR_REL, press enter to git diff..." x
	git diff -- "$PKGDIR_REL"
fi

cat >&2 <<eof
Automatic update of $PKG finished; now it's your turn to manually review it.

Deal with any FIXMEs mentioned above, by editing the corresponding source files
in $PKGDIR_REL (and NOT the build directory as mentioned). When done, git-add
your changes and re-run this command (\`./update.sh $*\`).

Check that your fixes actually get rid of the FIXMEs. Of course, you may ignore
FIXMEs listed in hint files, indicated by (.), assuming you actually fixed the
issues in the corresponding non-hint files. (We have no way to auto-detect this
so you have to be honest!)

If satisfied with the output, run \`./release.sh $*\` to finalise your changes
in the changelog and build a release-ready .dsc in build/. Assuming it runs
successfully, you may \`dput\` the results afterwards.
eof

#!/bin/sh

. ./vars.sh.frag

if [ ! -d "$PKGDIR/debian" ]; then
	mkdir -p "$PKGDIR/debian"
	echo 'overlay = "."' > "$PKGCFG"
	git add "$PKGDIR"
fi
if [ ! -f "$PKGDIR/debian/copyright" ]; then
	echo "FIXME fill me in using ./copyright.debcargo.hint as a guide" > "$PKGDIR/debian/copyright"
fi

rm -rf "$BUILDDIR" "$(dirname "$BUILDDIR")/rust-$PKG-$VER_$VER"*.orig.tar.*
$DEBCARGO package --config "$PKGCFG" --directory "$BUILDDIR" "$PKG" "$VER"

if ! git diff --quiet -- "$PKGDIR_REL"; then
	read -p "Update wrote some changes to $PKGDIR_REL, press enter to git diff..." x
	git diff -- "$PKGDIR_REL"
fi

cat >&2 <<eof
Automatic update of $PKG finished; now it's your turn to manually review it.

Deal with any FIXMEs mentioned above, by editing the corresponding source files
in $PKGDIR_REL - and NOT the build directory as mentioned. If a hint file is
listed, indicated by (.), you should edit the *NON*-hint file, without the
suffix .debcargo.hint, and git-add the hint file exactly as output by debcargo.
So for example to deal with a FIXME in build/PKG/debian/copyright.debcargo.hint
you should edit src/PKG/debian/copyright.

When done, git-add your changes plus any unmodified hint files, and re-run this
command (\`./update.sh $*\`).

Check that your fixes actually get rid of the FIXMEs. Of course, you can ignore
FIXMEs listed in hint files, assuming you actually fixed the issues in the
corresponding non-hint files. (We have no way to auto-detect this so you have
to be honest!) You should also ignore the FIXME in the Distribution field in
the top entry of debian/changelog, that will be dealt with in the next step.

If satisfied with the output, run \`./release.sh $*\` to finalise your changes
in the changelog and build a release-ready .dsc in build/. Assuming it runs
successfully, you may \`dput\` the results afterwards. If you're not a Debian
Developer and are unable to upload, please don't run this script because it
will commit the wrong thing to git; instead get a DD to run it on your behalf.
eof

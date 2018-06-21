#!/bin/sh

. ./vars.sh.frag

if [ -n "$VER" ]; then
	if [ ! -d "$PWD/src/$PKGBASE" ]; then
		abort 1 "Using crate $CRATE with version $VER but default-version is not packaged." \
		"Package that first by running this script without the explicit version."
	fi
fi
if [ ! -d "$PKGDIR/debian" ]; then
	mkdir -p "$PKGDIR/debian"
	echo 'overlay = "."' > "$PKGCFG"
	git add "$PKGDIR"
fi
if [ ! -f "$PKGDIR/debian/copyright" ]; then
	echo "FIXME fill me in using ./copyright.debcargo.hint as a guide" > "$PKGDIR/debian/copyright"
fi
if [ -n "$VER" -a "$(sed -ne 's/^semver_suffix\s*=\s*//p' "$PKGCFG")" != "true" ]; then
	if grep -q semver_suffix "$PKGCFG"; then
		sed -i -e 's/^\(semver_suffix\s*=\s*\).*/\1true/' "$PKGCFG"
	else
		sed -i -e '1isemver_suffix = true' "$PKGCFG"
	fi
fi

rm -rf "$BUILDDIR" "$(dirname "$BUILDDIR")/rust-${PKGNAME}_$VER"*.orig.tar.*
$DEBCARGO package --config "$PKGCFG" --directory "$BUILDDIR" "$CRATE" "$VER"

if ! git diff --quiet -- "$PKGDIR_REL"; then
	read -p "Update wrote some changes to $PKGDIR_REL, press enter to git diff..." x
	git diff -- "$PKGDIR_REL"
	echo >&2 "-- end of git diff --"
fi

cat >&2 <<eof
Automatic update of $CRATE finished; now it's your turn to manually review it.

Deal with any FIXMEs mentioned above, by editing any corresponding source files
in $PKGDIR_REL. If a hint file is listed, indicated by (•), you should edit the
*NON*-hint file, without the suffix .debcargo.hint, and git-add the hint file
exactly as output by debcargo. So for example:

to deal with a FIXME in:
	    build/$PKGNAME/debian/copyright.debcargo.hint
you should edit:
	    src/$PKGNAME/debian/copyright
and git-add, without editing:
	    src/$PKGNAME/debian/copyright.debcargo.hint

When done, git-add your changes plus any unmodified hint files, and re-run this
command (\`./update.sh $*\`).

Check that your fixes actually get rid of the FIXMEs. Of course, you can ignore
FIXMEs listed in hint files, assuming you actually fixed the issues in the
corresponding non-hint files. (We have no way to auto-detect this so you have
to be honest!) You should also ignore the FIXME in the Distribution field in
the top entry of debian/changelog, that will be dealt with in the next step.

When satisfied with the output, you can commit and push all your changes. Then,
ask a Debian Developer to run \`./release.sh $*\` to finalise your changes in
the changelog and build a release-ready .dsc in build/. Assuming it runs
successfully, they may \`dput\` the results afterwards. If you're not a Debian
Developer and are unable to upload, please don't run that script because it
will add inaccurate commits to git stating that the package has been uploaded.
eof

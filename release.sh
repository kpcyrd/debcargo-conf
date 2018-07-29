#!/bin/sh

. ./vars.sh.frag

if test ! -d $PKGDIR_REL; then
    abort 1 "Cannot find $PKGDIR_REL. Did you run ./new-package.sh before?"
fi

git diff --quiet --cached || \
abort 1 "You have other pending changes to git, please complete it or stash it away and re-run this script."

git diff --quiet -- "$PKGDIR_REL" || \
abort 1 "Please git-add your changes to $PKGDIR_REL before running"

RELBRANCH="pending-$PKGNAME"
git fetch origin --prune

if head -n1 "$PKGDIR/debian/changelog" | grep -qv UNRELEASED-FIXME-AUTOGENERATED-DEBCARGO; then
	abort 0 "Package already released."
fi

PREVBRANCH="$(git rev-parse --abbrev-ref HEAD)"
case "$PREVBRANCH" in
pending-$PKGNAME)	true;;
pending-*)	abort 1 "You are on a pending-release branch for a package other than $PKGNAME, $0 can only be run on another branch, like master";;
*)	if git rev-parse -q --verify "refs/heads/$RELBRANCH" >/dev/null || \
	   git rev-parse -q --verify "refs/remotes/origin/$RELBRANCH" >/dev/null; then
		git checkout "$RELBRANCH"
	else
		git checkout -b "$RELBRANCH"
	fi;;
esac

if head -n1 "$PKGDIR/debian/changelog" | grep -qv UNRELEASED-FIXME-AUTOGENERATED-DEBCARGO; then
	git checkout "$PREVBRANCH"
	abort 0 "Package already released on branch $RELBRANCH. If that was a mistake then run \`git branch -D $RELBRANCH\`, and re-run this script ($0 $*). You might have to delete the remote branch too."
fi

( cd "$PKGDIR"
sed -i -e s/UNRELEASED-FIXME-AUTOGENERATED-DEBCARGO/UNRELEASED/ debian/changelog
dch -m -r -D unstable ""
git add debian/changelog
)

revert_git_changes() {
	git reset
	git checkout -- "$PKGDIR/debian/changelog"
	git checkout "$PREVBRANCH"
	git branch -d "$RELBRANCH"
}

if ! run_debcargo --changelog-ready; then
	revert_git_changes
	abort 1 "Release attempt failed to run debcargo, probably the package needs updating (./update.sh $*)"
fi

if ! git diff --exit-code -- "$PKGDIR_REL"; then
	revert_git_changes
	abort 1 "Release attempt resulted in git diffs to $PKGDIR_REL, probably the package needs updating (./update.sh $*)"
fi

check_build_deps() {
	local success=true
	sed -ne '/Build-Depends/,/^[^ ]/p' "build/$PKGNAME/debian/control" | \
	grep -Eo 'librust-.*+.*-dev' | \
	{ while read pkg; do
		if [ $(apt-cache showpkg "$pkg" | grep ^Package: | wc -l) = 0 ]; then
			echo >&2 "Build-Dependency not yet in debian: $pkg (don't forget to '{apt,cargo} update')"
			success=false
		fi
	done; $success; }
}

if ! check_build_deps; then
	revert_git_changes
	abort 1 "Release attempt detected build-dependencies not in Debian (see messages above), release those first."
fi

git commit -m "Release package $PKGNAME"

( cd "$BUILDDIR" && dpkg-buildpackage -d -S --no-sign )

cat >"$BUILDDIR/../sbuild-and-sign.sh" <<'eof'
#!/bin/sh
set -e

if [ -n "$DEBCARGO" ]; then
	true
elif which debcargo >/dev/null; then
	DEBCARGO=$(which debcargo)
elif [ -f "$HOME/.cargo/bin/debcargo" ]; then
	DEBCARGO="$HOME/.cargo/bin/debcargo"
else
	abort 1 "debcargo not found, run \`cargo install debcargo\` or set DEBCARGO to point to it"
fi

CRATE="$1"
VER="$2"
DISTRIBUTION="${DISTRIBUTION:-unstable}"

PKGNAME=$($DEBCARGO deb-src-name "$CRATE" $VER || abort 1 "couldn't find crate $CRATE")
DEBVER=$(dpkg-parsechangelog -l $PKGNAME/debian/changelog -SVersion)
DEBSRC=$(dpkg-parsechangelog -l $PKGNAME/debian/changelog -SSource)
DEB_HOST_ARCH=$(dpkg-architecture -q DEB_HOST_ARCH)
if [ -z "$CHROOT" ] && schroot -i -c "debcargo-unstable-${DEB_HOST_ARCH}-sbuild" >/dev/null 2>&1; then
	CHROOT="debcargo-unstable-${DEB_HOST_ARCH}-sbuild"
fi

sbuild --no-source --arch-any --arch-all ${CHROOT:+-c $CHROOT }${DISTRIBUTION:+-d $DISTRIBUTION }${DEBSRC}_${DEBVER}.dsc
changestool ${DEBSRC}_${DEBVER}_${DEB_HOST_ARCH}.changes adddsc ${DEBSRC}_${DEBVER}.dsc
debsign ${DEBSIGN_KEYID:+-k $DEBSIGN_KEYID }--no-re-sign ${DEBSRC}_${DEBVER}_${DEB_HOST_ARCH}.changes
eof
chmod +x "$BUILDDIR/../sbuild-and-sign.sh"

DEBVER=$(dpkg-parsechangelog -l build/$PKGNAME/debian/changelog -SVersion)
DEBSRC=$(dpkg-parsechangelog -l build/$PKGNAME/debian/changelog -SSource)
DEB_HOST_ARCH=$(dpkg-architecture -q DEB_HOST_ARCH)
cat >&2 <<eof
Release of $CRATE ready as a source package in ${BUILDDIR#$PWD/}. You need to
perform the following steps:

Build the package if necessary, and upload
==========================================

If the source package is already in Debian and this version does not introduce
new binaries, then you can just go ahead and directly dput the source package.

  dput ${DEBSRC}_${DEBVER}_source.changes

If this is a NEW source package or introduces NEW binary packages not already
in the Debian archive, you will need to build a binary package out of it. The
recommended way is to run something like:

  cd build
  ./sbuild-and-sign.sh $CRATE $VER
  dput ${DEBSRC}_${DEBVER}_${DEB_HOST_ARCH}.changes

This assumes you followed the "DD instructions" in README.rst, for setting up
a build environment for release.

If the build fails e.g. due to missing Build-Dependencies you should revert
what I did (see below) and package those missing Build-Dependencies first.

Push this pending-release branch
================================

After you have uploaded the package with dput(1), you should push $RELBRANCH so
that other people see it's been uploaded. Then, checkout another branch like
master to continue development on other packages.

  git push origin $RELBRANCH && git checkout master

Merge the pending-release branch when ACCEPTED
==============================================

When it's ACCEPTED by the Debian FTP masters, you may then merge this branch
back into the master branch, delete it, and push these updates to origin.

  git checkout master && git merge $RELBRANCH && git branch -d $RELBRANCH
  git push origin master :$RELBRANCH

----

The above assumes you are a Debian Developer with upload rights. If not, you
should revert what I just did. To do that, run:

  git checkout master && git branch -D $RELBRANCH

Then ask a Debian Developer to re-run me ($0 $*) on your behalf. Also add your
crate to the "Ready for upload" list in TODO.rst so it's easy to track.
eof

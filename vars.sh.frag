set -e

abort() { local x=$1; shift; echo >&2 "$0: abort: $@"; exit "$x"; }

DEBCARGO_GIT=${DEBCARGO_GIT:-$PWD/../debcargo}
DEBCARGO=${DEBCARGO:-$DEBCARGO_GIT/target/debug/debcargo}
PKG="$1"
VER="$2"

PKGNAME=$($DEBCARGO deb-src-name "$PKG" || abort 1 "couldn't find package $PKG")
PKGDIR_REL="src/$PKGNAME"
PKGDIR="$PWD/$PKGDIR_REL"
BUILDDIR="$PWD/build/$PKGNAME"
PKGCFG="$PKGDIR/debian/debcargo.toml"

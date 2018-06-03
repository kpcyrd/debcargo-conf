set -e

DEBCARGO_GIT=${DEBCARGO_GIT:-$PWD/../debcargo}
DEBCARGO=${DEBCARGO:-$DEBCARGO_GIT/target/debug/debcargo}
PKG="$1"

PKGNAME=$($DEBCARGO deb-src-name "$PKG")
PKGDIR_REL="src/$PKGNAME"
PKGDIR="$PWD/$PKGDIR_REL"
BUILDDIR="$PWD/build/$PKGNAME"
PKGCFG="$PKGDIR/debian/debcargo.toml"

abort() { local x=$1; shift; echo >&2 "$0: abort: $@"; exit "$x"; }

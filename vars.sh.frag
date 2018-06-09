set -e

abort() { local x=$1; shift; echo >&2 "$0: abort: $@"; exit "$x"; }

if [ -n "$DEBCARGO" ]; then
	true
elif which debcargo >/dev/null; then
	DEBCARGO=$(which debcargo)
elif [ -f "$HOME/.cargo/bin/debcargo" ]; then
	DEBCARGO="$HOME/.cargo/bin/debcargo"
else
	abort 1 "debcargo not found, run \`cargo install debcargo\` or set DEBCARGO to point to it"
fi

test -x "$DEBCARGO" || abort 1 "debcargo found but not executable: $DEBCARGO"

PKG="$1"
VER="$2"

PKGNAME=$($DEBCARGO deb-src-name "$PKG" "$VER" || abort 1 "couldn't find package $PKG")
PKGDIR_REL="src/$PKGNAME"
PKGDIR="$PWD/$PKGDIR_REL"
BUILDDIR="$PWD/build/$PKGNAME"
PKGCFG="$PKGDIR/debian/debcargo.toml"

mkdir -p "$(dirname $BUILDDIR)"

if [ -z "$PKG" ]; then
	abort 2 "Usage: $0 <package> [<version>]"
fi

set -e

abort() { local x=$1; shift; for i in "$@"; do echo >&2 "$0: abort: $i"; done; exit "$x"; }

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
dcver=$($DEBCARGO --version | sed -ne 's/debcargo //p')
case $dcver in
2.0.*)	abort 1 "unsupported debcargo version: $dcver";;
2.*.*)	true;;
*)	abort 1 "unsupported debcargo version: $dcver";;
esac

CRATE="$1"
VER="$2"

PKGNAME=$($DEBCARGO deb-src-name "$CRATE" $VER || abort 1 "couldn't find crate $CRATE")
PKGBASE=$($DEBCARGO deb-src-name "$CRATE" || abort 1 "couldn't find crate $CRATE")
PKGDIR_REL="src/$PKGNAME"
PKGDIR="$PWD/$PKGDIR_REL"
BUILDDIR="$PWD/build/$PKGNAME"
PKGCFG="$PKGDIR/debian/debcargo.toml"

mkdir -p "$(dirname $BUILDDIR)"

if [ -z "$CRATE" ]; then
	abort 2 "Usage: $0 <crate> [<version>]"
fi

Crates to package
=================

The lists below are calculated using some combinations of running::

  tests/sh/cargo-tree-deb-rec <binary-crate>

from the ``debcargo.git`` repository.

Base packages
-------------

The below are transitive dependencies of {debcargo, exa, ripgrep, mdbook,
xi-core-lib} that have no other rust dependencies, i.e. can be built right now
with what's already in Debian. Note that some of them are older versions and
the newer versions *do* have other dependencies that must be packaged first.

This list is not set in stone, newer versions of those programs may make some
of the older versions obsolete. Use your own judgement on what to package, or
what to remove from the list if it's not longer necessary.

"-" means already done, pending upload. When they get ACCEPTED you can rm from here.

cc-1.0.17
crossbeam-0.3.2
foreign-types-shared-0.1.1
fuchsia-zircon-sys-0.3.3
lazycell-0.6.0
matches-0.1.6
openssl-probe-0.1.2
percent-encoding-1.0.1
quick-error-1.2.2
quote-0.3.15
redox_syscall-0.1.40
regex-syntax-0.4.2
regex-syntax-0.5.6
rustc-demangle-0.1.8
scopeguard-0.3.3
- shlex-0.1.1
- string_cache_shared-0.3.0
- strsim-0.7.0
vcpkg-0.2.4
- vec_map-0.8.1
- version_check-0.1.3
winapi-0.2.8
xi-unicode-0.1.0

dependencies of mdbook/exa
--------------------------

ansi_term-0.8.0 -- needed by exa
bitflags-0.9.1 -- exa, mdbook
byteorder-0.4.2 -- exa
language-tags-0.2.2 -- mdbook
lazy_static-0.2.11 -- exa
mac-0.1.1 -- mdbook
maplit-1.0.1 -- mdbook
modifier-0.1.0 -- exa
natord-1.0.9 -- exa
nom-1.2.4 -- exa
open-1.2.1 -- mdbook
pest-1.0.6 -- mdbook
precomputed-hash-0.1.1 -- mdbook
regex-syntax-0.3.9 -- exa
scoped_threadpool-0.1.9 -- exa
sequence_trie-0.3.5 -- mdbook
serde-0.9.15 -- xi-core-lib
siphasher-0.2.2 -- mdbook
strum-0.9.0 -- mdbook
traitobject-0.1.0 -- mdbook
typeable-0.1.2 -- mdbook
utf8-ranges-0.1.3 -- exa


dependencies of debcargo
------------------------

Roughly in dependency order, i.e. earlier packages have less dependencies

winapi-x86_64-pc-windows-gnu v0.4.0
winapi-i686-pc-windows-gnu v0.4.0
winapi v0.3.4
same-file v1.0.2
walkdir v2.1.4
serde v1.0.66
toml v0.4.6
- textwrap v0.10.0
remove_dir_all v0.5.1
libc v0.2.42
fuchsia-zircon-sys v0.3.3
bitflags v1.0.3
fuchsia-zircon v0.3.3
rand v0.4.2
tempdir v0.3.7
xattr v0.2.1
redox_syscall v0.1.40
filetime v0.2.1
tar v0.4.15
proc-macro2 v0.4.5
quote v0.6.3
syn v0.14.2
serde_derive v1.0.66
semver-parser v0.7.0
semver v0.9.0
utf8-ranges v1.0.0
void v1.0.2
- unreachable v1.0.0
lazy_static v1.0.1
thread_local v0.3.5
ucd-util v0.1.1
regex-syntax v0.6.0
- memchr v2.0.1
aho-corasick v0.6.4 (waiting for librust-memchr-2)
regex v1.0.0
either v1.5.0
itertools v0.7.8
glob v0.2.11
percent-encoding v1.0.1
matches v0.1.6
unicode-bidi v0.3.4
idna v0.1.4
url v1.7.0
vcpkg v0.2.3
cc v1.0.17
openssl-sys v0.9.32
openssl-probe v0.1.2
log v0.4.1 (waiting for cfg-id to be ACCEPTED)
cmake v0.1.31
libz-sys v1.0.18
libssh2-sys v0.2.7
curl-sys v0.4.5
libgit2-sys v0.7.3
git2 v0.7.1
miniz-sys v0.1.10
flate2 v1.0.1
synom v0.11.3
quote v0.3.15
syn v0.11.11
synstructure v0.6.1
failure_derive v0.1.1
rustc-demangle v0.1.8
backtrace-sys v0.1.23
backtrace v0.3.8
failure v0.1.1
vec_map v0.8.1
textwrap v0.9.0
strsim v0.7.0
redox_termios v0.1.1
termion v1.5.1
atty v0.2.10
ansi_term v0.11.0
clap v2.31.2
time v0.1.40
num-traits v0.2.4
num-integer v0.1.38
chrono v0.4.2
wincolor v0.1.6
termcolor v0.3.6
tempfile v3.0.2
itoa v0.4.1
dtoa v0.4.2
serde_json v1.0.19
serde_ignored v0.0.4
- num_cpus v1.8.0
socket2 v0.3.6
miow v0.3.1
lazycell v0.6.0
jobserver v0.1.11
regex-syntax v0.5.6
regex v0.2.11
fnv v1.0.6
globset v0.4.0
crossbeam v0.3.2
ignore v0.4.2
scopeguard v0.3.3
home v0.3.3
hex v0.3.2
winapi v0.2.8
schannel v0.1.12
kernel32-sys v0.2.2
curl v0.4.12
git2-curl v0.8.1
fs2 v0.4.3
filetime v0.1.15
quick-error v1.2.2
humantime v1.1.1
env_logger v0.5.10
foreign-types-shared v0.1.1
foreign-types v0.3.2
openssl v0.10.9
commoncrypto-sys v0.2.0
commoncrypto v0.2.0
crypto-hash v0.3.1
crates-io v0.16.0
core-foundation-sys v0.5.1
core-foundation v0.5.1
cargo v0.27.0

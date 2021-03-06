=================
Crates to package
=================

Eventual goals
==============

To see lists of interesting binary crates, you can run something like::

  $ apt-get install koji-client
  $ koji -p fedora search package 'rust-*' | cut -b6- | dev/filter-binary-crates.sh

Current output (on 2018-07-08) is:

- aho-corasick
- docopt
- pulldown-cmark
- ripgrep
- fd-find
- exa
- cpp_demangle
- permutate
- cbindgen
- rustdoc-stripper
- difference
- pretty-git-prompt
- peg
- varlink
- varlink-cli

Sccache is also helpful for reducing the build-time of things like firefox and thunderbird

- sccache https://github.com/mozilla/sccache

There are also more binaries here:

https://github.com/rust-unofficial/awesome-rust


Immediate goals
===============

The lists below are calculated using some combinations of running::

  tests/sh/cargo-tree-deb-rec <binary-crate>

from the ``debcargo.git`` repository.


Ready for upload (Request For Sponsor)
--------------------------------------

These packages are prepared in the master branch and can be uploaded because
all required dependencies are available in main::

    none

Delayed/problematic::

    bitflags-0.9.1 -- dependency of pulldown-cmark
    winapi-0.2.8 -- dependency of mio, iovec, etc
    safemem-0.2.1 -- dependency of base64 <- hyper
    miniz-sys-0.1.10 -- dependency of flate2 <- cargo <- debcargo
    crossbeam-utils-0.3.2 -- ???
    lazycell-0.6.0 -- dependency of mio, cargo-0.27
    gcc-0.3.54 -- ???

infinity0: I've omitted the above for now since they are older versions, let's
try to get the reverse-dependent crates using the latest versions of them.)

infinity0: I've also omitted miniz-sys for now because it bundles an old
version of miniz, and this should be discussed a bit further because it's not
within normal Debian practise. See upstream issues:

- https://github.com/alexcrichton/flate2-rs/issues/160
- https://github.com/alexcrichton/flate2-rs/issues/143


Base packages
-------------

The below are transitive dependencies of {debcargo, exa, ripgrep, mdbook,
xi-core-lib} that have no other rust dependencies, i.e. can be built right now
with what's already in Debian. Note that some of them are older versions and
the newer versions *do* have other dependencies that must be packaged first.

This list is not set in stone, newer versions of those programs may make some
of the older versions obsolete. Use your own judgement on what to package, or
what to remove from the list if it's not longer necessary.

"-" means already done, pending upload. When they get ACCEPTED you can rm from here::

    lazycell-0.6.0
    quote-0.3.15
    regex-syntax-0.4.2
    regex-syntax-0.5.6
    winapi-0.2.8

dependencies of mdbook/exa
--------------------------

::

    ansi_term-0.8.0 -- needed by exa
    bitflags-0.9.1 -- exa, mdbook
    byteorder-0.4.2 -- exa
    language-tags-0.2.2 -- mdbook
    lazy_static-0.2.11 -- exa
    mac-0.1.1 -- mdbook
    maplit-1.0.1 -- mdbook
    modifier-0.1.0 -- exa
    nom-1.2.4 -- exa
    open-1.2.1 -- mdbook
    pest-1.0.6 -- mdbook
    precomputed-hash-0.1.1 -- mdbook
    regex-syntax-0.3.9 -- exa
    - scoped_threadpool-0.1.9 -- exa
    sequence_trie-0.3.5 -- mdbook
    serde-0.9.15 -- xi-core-lib
    strum-0.9.0 -- mdbook
    - term-grid-0.1.7 - exa
    traitobject-0.1.0 -- mdbook
    typeable-0.1.2 -- mdbook
    utf8-ranges-0.1.3 -- exa

dependencies of debcargo
------------------------

Roughly in dependency order, i.e. earlier packages have less dependencies.
Some versions might be out-of-date::

    walkdir v2.1.4
    ** remove_dir_all v0.5.1
    fuchsia-zircon v0.3.3
    rand v0.4.2
    tempdir v0.3.7
    filetime v0.2.1
    tar v0.4.15
    - quote v0.6.3
    syn v0.14.2
    serde_derive v1.0.66
    semver v0.9.0
    itertools v0.7.8
    - unicode-bidi v0.3.4
    idna v0.1.4
    url v1.7.0
    openssl-sys v0.9.32
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
    backtrace-sys v0.1.23
    backtrace v0.3.8
    failure v0.1.1
    - textwrap v0.9.0
    - redox_termios v0.1.1
    termion v1.5.1
    atty v0.2.10
    clap v2.31.2
    - time v0.1.40
    chrono v0.4.2
    - termcolor v0.3.6
    tempfile v3.0.2
    - serde_json v1.0.19
    serde_ignored v0.0.4
    socket2 v0.3.6
    miow v0.3.1
    lazycell v0.6.0
    jobserver v0.1.11
    regex-syntax v0.5.6
    regex v0.2.11 -- largely compatible with regex 1, try patching Cargo.toml to use latter
    - globset v0.4.0
    - crossbeam v0.3.2
    ignore v0.4.2
    home v0.3.3
    winapi v0.2.8
    kernel32-sys v0.2.2
    curl v0.4.12
    git2-curl v0.8.1
    fs2 v0.4.3
    filetime v0.1.15
    - quick-error v1.2.2
    humantime v1.1.1
    env_logger v0.5.10
    - foreign-types-shared v0.1.1
    foreign-types v0.3.2
    openssl v0.10.9
    commoncrypto-sys v0.2.0
    commoncrypto v0.2.0
    crypto-hash v0.3.1
    crates-io v0.16.0
    core-foundation-sys v0.5.1
    core-foundation v0.5.1
    cargo v0.27.0

dependencies of ripgrep
-----------------------

Generated with:
$ cargo tree --all-features

Nothing = Done
Italic = Pending
Bold = Remaining

ripgrep v0.8.1

**├── atty v0.2.10**

│   └── libc v0.2.40

├── bytecount v0.3.1

**│   └── simd v0.2.2**

**├── clap v2.31.2**

│   ├── ansi_term v0.11.0

**│   ├── atty v0.2.10 (*)**

│   ├── bitflags v1.0.3

│   ├── strsim v0.7.0

│   ├── textwrap v0.9.0

│   │   └── unicode-width v0.1.4

│   └── unicode-width v0.1.4 (*)

*├── encoding_rs v0.7.2*

│   ├── cfg-if v0.1.3

**│   └── simd v0.2.2 (*)**

**├── globset v0.4.0**

│   ├── aho-corasick v0.6.4

│   │   └── memchr v2.0.1

│   │       └── libc v0.2.40 (*)

│   ├── fnv v1.0.6

│   ├── log v0.4.1

│   │   └── cfg-if v0.1.3 (*)

│   ├── memchr v2.0.1 (*)

│   └── regex v1.0.1

│       ├── aho-corasick v0.6.4 (*)

│       ├── memchr v2.0.1 (*)

│       ├── regex-syntax v0.6.0

│       │   └── ucd-util v0.1.1

│       ├── thread_local v0.3.5

│       │   ├── lazy_static v1.0.0

│       │   └── unreachable v1.0.0

│       │       └── void v1.0.2

│       └── utf8-ranges v1.0.0

**├── grep v0.1.8**

│   ├── log v0.4.1 (*)

│   ├── memchr v2.0.1 (*)

│   ├── regex v1.0.1 (*)

│   └── regex-syntax v0.6.0 (*)

**├── ignore v0.4.2**

│   ├── crossbeam v0.3.2

**│   ├── globset v0.4.0**

│   ├── lazy_static v1.0.0 (*)

│   ├── log v0.4.1 (*)

│   ├── memchr v2.0.1 (*)

│   ├── regex v1.0.1 (*)

│   ├── same-file v1.0.2

│   ├── thread_local v0.3.5 (*)

**│   └── walkdir v2.1.4**

│       └── same-file v1.0.2 (*)

├── lazy_static v1.0.0 (*)

├── libc v0.2.40 (*)

├── log v0.4.1 (*)

├── memchr v2.0.1 (*)

├── memmap v0.6.2

│   └── libc v0.2.40 (*)

├── num_cpus v1.8.0

│   └── libc v0.2.40 (*)

├── regex v1.0.1 (*)

├── same-file v1.0.2 (*)

*└── termcolor v0.3.6*

[build-dependencies]

**├── clap v2.31.2 (*)**

└── lazy_static v1.0.0 (*)

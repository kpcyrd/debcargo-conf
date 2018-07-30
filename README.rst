Instructions
============

To get set up, run::

  apt update && apt build-dep cargo && apt install cargo dh-cargo
  cargo install debcargo # eventually will be replaced by "apt install debcargo"

Then for each new package:

**To package a new crate, or to update an existing crate:**

| $ ``./new-package.sh <rust-crate-name>``, or
| $ ``./update.sh <rust-crate-name>``
|

and follow its instructions.

Note that new-package.sh is just a symlink to update.sh, to help newcomers.

**To package an older version of a crate:**

To maintain an old version of a crate alongside the latest one, first make sure
the latest version is packaged by doing all of the above, then run:

| $ ``./new-package.sh <rust-crate-name> <old-version>``, or
| $ ``./update.sh <rust-crate-name> <old-version>``
|

and follow its instructions. To save time, you can first copy anything relevant
from ``src/<rust-crate-name>`` to ``src/<rust-crate-name>-<old-version>``, then
adapt it as needed.

**To prepare a release:**

| $ ``./release.sh <rust-crate-name>``, or
| $ ``./release.sh <rust-crate-name> <old-version>`` as appropriate
|

This prepares the necessary Debian files in ``build/``, and creates a git
branch to manage the packaging until it is accepted in Debian itself. You need
to run additional commands after this - more specific instructions are given to
you about this, by the script after you run it.


DD instructions
===============

To set up a suitable build environment for ``./release.sh``::

  $ apt-get install devscripts reprepro
  $ sudo sbuild-createchroot --include=eatmydata,ccache,gnupg,dh-cargo,cargo,lintian \
      --chroot-prefix debcargo-unstable unstable \
      /srv/chroot/debcargo-unstable-amd64-sbuild http://deb.debian.org/debian


NEWS
====

2018-07-06
----------

Great news, we started to upload packages in the archives. 22 have been accepted
and about 20 are pending in NEW.


2018-06-20
----------

We are about to upload a few hundred rust packages to Debian. Do not submit
ITPs for these, it is unnecessary since we're the only ones uploading, there is
no chance of conflict, and it is only spam for the bug tracker. Please instead
co-ordinate uploads on the #debian-rust IRC channel.


TODO
====

Maybe use ``--copyright-guess-harder``.

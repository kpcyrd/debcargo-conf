Instructions
============

First, ``cargo install debcargo``. Then for each new package:

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

and follow its instructions. To make this easier, you can start by copying
anything relevant from ``src/<rust-crate-name>`` to
``src/<rust-crate-name>-<old-version>``, then adapting it as needed.

**To prepare the release:**

| $ ``./release.sh <rust-crate-name>``
|

This prepares the necessary Debian files in ``build/``. It also creates a git
branch to manage the packaging until it is accepted in Debian itself. More
specific instructions are given to you, when you run the script.


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

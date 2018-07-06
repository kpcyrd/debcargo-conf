Instructions
============

``cargo install debcargo``, then for each new package:

**To package a new crate:**

$ ``./new-package.sh <rust-crate-name>`` and follow its instructions.

**To update a crate:**

$ ``./update.sh <rust-crate-name>``

Note that new-package.sh is just a symlink to update.sh. This has been created
to help new comers.

**To package an older version of a crate:**

$ ``./update.sh <rust-crate-name> <old-version>``

To maintain an old version of a crate alongside the latest one, first
make sure the latest version is packaged by doing all of the above, then run
the command above and copy anything relevant from the config directory
for the latest version, to that for the old version.


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

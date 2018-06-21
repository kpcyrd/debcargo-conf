Instructions
============

``cargo install debcargo``, then for each new package:

Run ``./update.sh <rust-crate-name>`` and follow its instructions.

(The above applies even for new Rust Debian packages.)

If you must maintain an old version of a crate alongside the latest one, first
make sure the latest version is packaged by doing all of the above, then run
``./update.sh <rust-crate-name> <old-version>``, then copy anything relevant
from the config directory for the latest version, to that for the old version.


NEWS
====

2018-06-20
----------

We are about to upload a few hundred rust packages to Debian. Do not submit
ITPs for these, it is unnecessary since we're the only ones uploading, there is
no chance of conflict, and it is only spam for the bug tracker. Please instead
co-ordinate uploads on the #debian-rust IRC channel.


TODO
====

Maybe use ``--copyright-guess-harder``.

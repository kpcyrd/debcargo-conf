Instructions
============

``cargo install debcargo``, then for each new package:

Run ``./update.sh <rust-crate-name>`` and follow its instructions.

(The above applies even for new Rust Debian packages.)


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

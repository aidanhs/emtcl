emtcl
=====

The imaginatively named emtcl lets you compile tcl with emscripten. It's pretty easy so there's not much here. The small amount there is is available under the 3-clause BSD license (see "LICENSE").

BUILD
-----

Pretty easy:

    $ make prep # One off prep - hacks.patch application and configure
    $ make      # Build libtcl.js

If you want to totally reset all build files in ./tcl/ and start again:

    $ make reset

emtcl
=====

The imaginatively named emtcl lets you compile tcl or jimtcl with emscripten. It's pretty easy so there's not much here. The small amount there is is available under the 3-clause BSD license (see "LICENSE").

Rather than trying to compile tclsh/jimsh and get stdin working, it instead compiles the tcl library and exposes some C api calls. See js/postJs.js for how this is done.

Current supported interpreters (and their versions) are:
 - tcl - core\_8\_6\_1
 - jimtcl - 0.75

BUILD
-----

Pretty easy (assuming you've got the emscripten sdk on your path):

    $ make tclprep # One off prep - hacks.patch application and configure
    $ make emtcl   # Build emtcl.js

or for jimtcl:

    $ make jimtclprep # One off prep - tweaks appropriate #defines
    $ make emjimtcl   # Build emjimtcl.js

If you want to totally reset all build files in ./tcl/ and start again:

    $ make reset

This removes all changes in there, so be careful!

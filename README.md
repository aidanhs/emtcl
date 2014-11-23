emtcl
=====

The imaginatively named emtcl lets you compile tcl or jimtcl with emscripten. It's pretty easy so there's not much here. The small amount there is is available under the 3-clause BSD license (see "LICENSE").

Rather than trying to compile tclsh/jimsh and get stdin working, it instead compiles the tcl library and exposes some C api calls. See js/postJs.js for how this is done.

Current supported interpreters (and their versions) are:
 - tcl - core\_8\_6\_1
 - jimtcl - 0.75

Tcl comes with a toy DOM library as a demo. See EXTRAS.

BUILD
-----

Pretty easy (assuming you've got the emscripten sdk on your path):

    $ make tclprep # One off prep - hacks.patch application and configure
    $ make emtcl   # Build emtcl.js

or for jimtcl:

    $ make jimtclprep # One off prep - tweaks appropriate #defines and configure
    $ make emjimtcl   # Build emjimtcl.js

If you want to totally reset all build files in ./tcl/ and ./jimtcl/ and start again:

    $ make reset

This removes all changes and untracked files in there, so be careful!

EXTRAS
------

EmTcl (not EmJimTcl) comes with a toy DOM library compiled into it by default
as a demonstration of how one could do interesting things.

It currently is a command of the form `dom attr|css selector key val`. It sets
the appropriate key in either the attribute or style dictionary of each element
returned by the selector. It will return the number of elements modified. Note
that style keys are in their camelcase form (backgroundColor vs background-color)
as the styles are changed in the element style dictionary.

You can see the code in opt/dom.c. If you really want to compile without it, do
`make emtcl EMTCLDOM=0`.

TODO
----

There are a number of broken things with each of these Tcl implementations.

tcl:

 - `clock` command isn't present. Caused by not calling `Tcl_Init`, would
   require embedding the `library` directory. Entirely possible, just not put
   the effort in.
 - `after 2000 {set ::cond_var 0}; vwait ::cond_var` doesn't work. This seems to
   be an emscripten problem, not sure how easy it is to solve.

jimtcl:

 - `package` command isn't present. Not sure of cause.
 - `Jim_InitStaticExtensions` isn't called. Not sure what the implications are.

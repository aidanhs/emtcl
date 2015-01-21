# Whether to build the optional `dom` command into tcl
EMTCLDOM?=1

# Optimisation to use for generating bc
BCFLAGS?=-Oz
# post-js happens later to write cwrap code conditional on tcl distro
EMFLAGS=\
	--pre-js js/preJs.js\
	--memory-init-file 0 -O3 --llvm-lto 3 --closure 0\
	#-s FORCE_ALIGNED_MEMORY=1 -s CLOSURE_COMPILER=1 -s CLOSURE_ANNOTATIONS=1\
	#-s NODE_STDOUT_FLUSH_WORKAROUND=0 -s RUNNING_JS_OPTS=1

EMTCLEXPORTS=\
	-s EXPORTED_FUNCTIONS="[\
		'_Tcl_CreateInterp',\
		'_Tcl_Eval',\
		'_Tcl_GetStringResult',\
		$$([ $(EMTCLDOM) = 1 ] && echo "'_CreateDomCmd'," || true)\
	]"

EMJIMTCLEXPORTS=\
	-s EXPORTED_FUNCTIONS="[\
		'_Jim_CreateInterp',\
		'_Jim_RegisterCoreCommands',\
		'_Jim_InitStaticExtensions',\
		'_Jim_Eval',\
		'_Jim_GetString',\
		'_Jim_GetResult',\
	]"

.PHONY: default tcl jimtcl tclprep jimtclprep reset

default: emtcl
emtcl: emtcl.js
emjimtcl: emjimtcl.js

emtcl.js: emtcl.bc
	emcc --post-js js/postJsTcl.js $(EMFLAGS) $(EMTCLEXPORTS) \
		$$([ $(EMTCLDOM) = 1 ] && echo '-Itcl/generic opt/dom.c' || true) $< -o $@

emjimtcl.js: emjimtcl.bc
	emcc --post-js js/postJsJimtcl.js $(EMFLAGS) $(EMJIMTCLEXPORTS) \
		-Ijimtcl jimtcl/jimgetresult.c $< -o $@

emtcl.bc:
	cd tcl/unix && emmake make
	[ -e $@ ] || \
		(T=$$(. ./tcl/unix/tclConfig.sh && echo $$TCL_LIB_FILE) && ln -s tcl/unix/$$T $@)

emjimtcl.bc:
	cd jimtcl && emmake make
	[ -e $@ ] || ln -s jimtcl/libjim.a $@

tclprep:
	cd tcl && git apply ../tclhacks.patch
	cd tcl/unix && emconfigure ./configure --disable-threads --disable-load --disable-shared
	cd tcl/unix && sed -i 's/-O2/$(BCFLAGS)/g' Makefile

jimtclprep:
	cd jimtcl && emconfigure ./configure --full --disable-docs --without-ext=regexp
	cd jimtcl && git apply ../jimtclhacks.patch
	cd jimtcl && sed -i 's/^\(CFLAGS = .*\)$$/\1 $(BCFLAGS)/g' Makefile

reset:
	@read -p "This nukes anything not git-controlled in ./tcl/ and ./jimtcl/, are you sure? Type 'y' if so: " P && [ $$P = y ]
	cd tcl && git reset --hard && git clean -f -x -d
	cd jimtcl && git reset --hard && git clean -f -x -d

EMFLAGS=\
	--pre-js js/preJs.js --post-js js/postJs.js\
	--memory-init-file 0 -O3 --llvm-lto 1 --closure 0

EMEXPORTS=\
	-s EXPORTED_FUNCTIONS="['_Tcl_Eval','_Tcl_CreateInterp','_Tcl_GetStringResult']"

default: libtcl.js

libtcl.js: libtcl.bc
	emcc $(EMFLAGS) $(EMEXPORTS) $< -o $@

libtcl.bc:
	cd tcl/unix && emmake make
	[ -e $@ ] || \
		(T=$$(. ./tcl/unix/tclConfig.sh && echo $$TCL_LIB_FILE) && ln -s tcl/unix/$$T $@)

prep:
	cd tcl && git apply ../hacks.patch
	cd tcl/unix && emconfigure ./configure --disable-threads --disable-load --disable-shared

reset:
	@read -p "This nukes anything not git-controlled in ./tcl/, are you sure? Type 'y' if so: " P && [ $$P = y ]
	cd tcl && git reset --hard && git clean -f -x -d

.PHONY: default prep reset

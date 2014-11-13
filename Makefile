EMFLAGS=\
	--pre-js js/preJs.js --post-js js/postJs.js\
	--memory-init-file 0 -O3 --llvm-lto 1 --closure 0

EMTCLEXPORTS=\
	-s EXPORTED_FUNCTIONS="[\
		'_Tcl_CreateInterp',\
		'_Tcl_Eval',\
		'_Tcl_GetStringResult'\
	]"

EMJIMTCLEXPORTS=\
	-s EXPORTED_FUNCTIONS="[\
		'_Jim_CreateInterp',\
		'_Jim_RegisterCoreCommands',\
		'_Jim_InitStaticExtensions'\
		'_Jim_Eval'\
		'_Jim_GetString'\
		'_Jim_GetResult'\
	]"

.PHONY: default tcl jimtcl tclprep jimtclprep reset

default: emtcl
emtcl: emtcl.js
emjimtcl: emjimtcl.js

emtcl.js: emtcl.bc
	emcc $(EMFLAGS) $(EMTCLEXPORTS) $< -o $@

emjimtcl.js: emjimtcl.bc
	emcc $(EMFLAGS) $(EMJIMTCLEXPORTS) $< -o $@

emtcl.bc:
	cd tcl/unix && emmake make
	[ -e $@ ] || \
		(T=$$(. ./tcl/unix/tclConfig.sh && echo $$TCL_LIB_FILE) && ln -s tcl/unix/$$T $@)

emjimtcl.bc:
	cd jimtcl && emmake make
	[ -e $@ ] || ln -s jimtcl/libjim.a $@

tclprep:
	cd tcl && git apply ../hacks.patch
	cd tcl/unix && emconfigure ./configure --disable-threads --disable-load --disable-shared

jimtclprep:
	cd jimtcl && emconfigure ./configure --full --disable-docs
	sed -i '/^#define HAVE_BACKTRACE/d' jimtcl/jimautoconf.h
	sed -i '/^#define HAVE_EXECVPE/d' jimtcl/jimautoconf.h
	sed -i '/^#define HAVE_SYS_SIGLIST/d' jimtcl/jimautoconf.h
	sed -i '1s/^/#include <unistd.h>\n/' jimtcl/jim-exec.c

reset:
	@read -p "This nukes anything not git-controlled in ./tcl/ and ./jimtcl/, are you sure? Type 'y' if so: " P && [ $$P = y ]
	cd tcl && git reset --hard && git clean -f -x -d
	cd jimtcl && git reset --hard && git clean -f -x -d

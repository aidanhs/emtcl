#include <tcl.h>
#include <string.h>
#include <emscripten.h>

int DomCmd(ClientData clientData, Tcl_Interp *interp, int objc, Tcl_Obj *CONST objv[]) {

	char *argsHelp = "attr|css selector key val";
	if (objc != 5) {
		Tcl_WrongNumArgs(interp, 1, objv, argsHelp);
		return TCL_ERROR;
	}

	const char *action   = Tcl_GetString(objv[1]);
	const char *selector = Tcl_GetString(objv[2]);
	const char *key      = Tcl_GetString(objv[3]);
	const char *val      = Tcl_GetString(objv[4]);

	Tcl_Obj *res;

	if (strcmp(action, "attr") != 0 && strcmp(action, "css") != 0) {
		res = Tcl_NewStringObj("Action must be attr or css", -1);
		Tcl_SetObjResult(interp, res);
		return TCL_ERROR;
	}

	int numChanged = EM_ASM_INT({
		var action   = Pointer_stringify($0);
		    selector = Pointer_stringify($1);
		    key      = Pointer_stringify($2);
		    val      = Pointer_stringify($3);
		var elts = document.querySelectorAll(selector);
		for (var i = 0; i < elts.length; i++) {
			if (action === "attr") {
				elts[i][key] = val;
			} else {
				elts[i].style[key] = val;
			}
		}
		return elts.length;
	}, action, selector, key, val);

	res = Tcl_NewIntObj(numChanged);
	Tcl_SetObjResult(interp, res);
	return TCL_OK;
}

void CreateDomCmd(Tcl_Interp *interp) {
	Tcl_CreateObjCommand(
		interp, "dom", DomCmd, (ClientData) NULL, (Tcl_CmdDeleteProc *) NULL
	);
}

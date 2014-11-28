      root['Module'] = Module;
    }
  };

  root.emjimtcl = root.TCL;
  delete root.TCL;

  root.emjimtcl();
  // Undo pollution of window
  delete window.Module;

  // Init emscripten stuff
  root.Module.run();

  var createInterp = root.Module.cwrap('Jim_CreateInterp', 'number', []);
  var registerCoreCommands = root.Module.cwrap('Jim_RegisterCoreCommands', 'number', ['number']);
  var initStaticExtensions = root.Module.cwrap('Jim_InitStaticExtensions', 'number', ['number']);
  root.CreateInterp = function () {
    var interp = createInterp();
    registerCoreCommands(interp);
    initStaticExtensions(interp);
    return interp;
  }
  root.Eval = root.Module.cwrap('Jim_Eval', 'number', [
      'number', // interp pointer
      'string'  // string to eval
  ]);
  var getResult = root.Module.cwrap('Jim_GetResult', 'number', ['number']);
  var getString = root.Module.cwrap('Jim_GetString', 'string', ['number', 'number']);
  root.GetStringResult = function (interp) {
    return getString(getResult(interp), 0);
  }

  self.emjimtcl = root;

})(this);

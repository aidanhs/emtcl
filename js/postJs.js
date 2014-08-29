      root['Module'] = Module;
    }
  };

  root.emtcl();
  // Undo pollution of window
  delete window.Module;

  // Init emscripten stuff
  root.Module.run();

  root.CreateInterp = root.Module.cwrap('Tcl_CreateInterp', 'number', []);
  root.Eval = root.Module.cwrap('Tcl_Eval', 'number', [
      'number', // interp pointer
      'string'  // string to eval
  ]);
  root.GetStringResult = root.Module.cwrap('Tcl_GetStringResult', 'string', [
      'number' // interp pointer
  ]);

  return root;

})();

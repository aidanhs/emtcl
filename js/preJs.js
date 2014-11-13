(function (self) {

  var root = {
    TCL: function () {
      var Module = {
        noInitialRun: true,
        noExitRuntime: true,
        preRun: [],
        postRun: []
      };

this.emtcl = (function () {

  var root = {
    emtcl: function () {
      var Module = {
        noInitialRun: true,
        noExitRuntime: true,
        preRun: [],
        postRun: []
      };

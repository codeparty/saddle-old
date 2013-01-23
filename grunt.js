module.exports = function (grunt) {
  "use strict";

  grunt.loadNpmTasks('grunt-testacular');


  // Project configuration.
  grunt.initConfig({

    testacularServer: {
      unit: {
        options: {
          keepalive: true
        },
        configFile: 'testacular.conf.js'
      }
    }

  });


  grunt.registerTask('test', 'testacularServer');


};
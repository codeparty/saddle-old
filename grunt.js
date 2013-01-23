module.exports = function (grunt) {
  'use strict';

  grunt.loadNpmTasks('grunt-testacular');
  grunt.loadNpmTasks('grunt-browserify');


  // Project configuration.
  grunt.initConfig({

    testacularServer: {
      client: {
        options: {
          keepalive: false
        },
        configFile: 'testacular.conf.js',
        watch: false
      }
    },

    browserify: {
      'test/build/browserified.js': {
        entries: ['test/*.coffee']
      }
    },

    watch: {
      browserify: {
        files: ['lib/*.js', 'test/*.coffee'],
        tasks: 'browserify'
      },
      test: {
        files: 'test/build/browserified.js',
        tasks: 'testacularServer'
      }
    }

  });


  grunt.registerTask('test', 'browserify testacularServer watch:browserify watch:test');


};
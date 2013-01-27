module.exports = function (grunt) {
  'use strict';

  grunt.loadNpmTasks('grunt-testacular');
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-bg-shell');


  // Project configuration.
  grunt.initConfig({

    bgShell: {
      watchCoffee: {
        cmd: './node_modules/coffee-script/bin/coffee -bw -o ./lib -c ./src'
      }
    },

    testacularServer: {
      client: {
        options: {
          keepalive: false
        },
        configFile: 'test/testacular.conf.js'
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
      }
    }

  });

  grunt.registerTask('default', 'bgShell:watchCoffee');

  grunt.registerTask('test', 'browserify testacularServer watch:browserify');


};
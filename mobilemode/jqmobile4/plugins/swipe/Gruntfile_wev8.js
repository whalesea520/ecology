/*global module */
module.exports = function( grunt ) {
  
  'use strict';

  grunt.initConfig({

    uglify: {
      options: {
        mangle: {
          except: ['Swipe']
        }
      },
      dist: {
        files: {
          'build/swipe.min_wev8.js': 'swipe_wev8.js'
        }
      }
    }

  });

  // build
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.registerTask('build', 'uglify');
  grunt.registerTask('default', 'build');
};
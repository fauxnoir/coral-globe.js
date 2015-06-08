module.exports = (grunt) ->

  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'

    # Wiredep config. Insert Bower packages into html files
    wiredep: {
      task: {
        src:['src/index.html']
      }
    }

    bower: {
    dev: {
        dest: 'src/'
        js_dest:'src/js/vendor'
        css_dest: 'src/css/vendor'
      }

    build: {
        dest: 'build/'
        js_dest: 'build/examples/js/vendor'
        css_dest: 'build/examples/css/vendor'
      }
    }

    watch: {
      coffee: {
        files: 'src/coffeescript/*.coffee'
        tasks: 'coffee:compile'
      }

      sass: {
        files: 'src/scss/*.scss'
        tasks: 'sass:compile'
      }

      bower: {
        files: 'bower.json'
        tasks: 'wiredep'
      }

    }

    coffee: {
      compile: {
        options: {
          bare: true
          join: true
          sourceMap: true
        }

        files: {
          'src/js/main.js': 'src/coffeescript/*.coffee'
        }
      }

      build: {
        options: {
          bare: true
          join: true
          sourceMap: true
        }

        files: {
          'src/js/coral.blob.js': 'src/coffeescript/coral.blob.coffee'
          'build/examples/js/main.js': 'src/coffeescript/main.coffee'
        }
      }
    }

    sass: {
      options: {
          sourceMap: true
      }
      compile: {
          files: {
              'src/css/main.css': 'src/scss/main.scss'
          }
      }
      }

    coffeelint: {
      lint: 'src/coffeescript/*.coffee'
    }

    uglify: {
      minify: {
        files: {
          'build/js/coral.blob.min.js': 'src/js/coral.blob.js'
        }
      }
    }

    copy: {
      build: {
        files: [
          {expand: false, src: ['src/index.html'], dest: 'build/examples/index.html', filter: 'isFile'}
        ]
      }
    }

    # Configuration for browser sync (auto refresh)
    browserSync: {
      bsFiles: {
        src: ['src/js/*.js', 'src/css/*.css', 'src/index.html']
      }

      options: {
        proxy: 'localhost.boilerplate.com/src'
        # server: {
        #   baseDir: 'src/'
        # }
      }
    }

  }

  # Load the grunt-wiredep task. This injects Bower components into html files
  grunt.loadNpmTasks 'grunt-wiredep'
  grunt.loadNpmTasks 'grunt-bower'
  grunt.loadNpmTasks 'grunt-contrib-watch' 
  grunt.loadNpmTasks 'grunt-contrib-coffee' 
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-browser-sync'
  grunt.loadNpmTasks 'grunt-sass'


  

  #  Default task(s)
  grunt.registerTask 'default', ['browserSync']
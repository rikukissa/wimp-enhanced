serverProc = null

module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files:
          "public/js/modules/*.js": "src/coffee/**/*.coffee"

        options:
          flatten: false
          bare: false

    jade:
      compile:
        files:
          "public/index.html": "src/jade/index.jade"

    stylus:
      compile:
        files:
          "public/css/*.css": "src/stylus/*.styl"

        options:
          compress: true

    watch:
      coffee:
        files: ["src/coffee/**/*.coffee"]
        tasks: ["coffee", "reload"]

      stylus:
        files: ["src/stylus/*.styl"]
        tasks: ["stylus", "reload"]

      jade:
        files: ["src/jade/*.jade"]
        tasks: ["jade", "reload"]

    reload:
      port: 6001
      proxy:
        host: 'localhost'
        port: 8001

  grunt.loadNpmTasks "grunt-reload"
  grunt.loadNpmTasks "grunt-shell"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-stylus"

  grunt.registerTask "server", () ->
    execServer = () ->
      exec = 'node_modules/coffee-script/bin/coffee'
      exec = __dirname + '/node_modules/.bin/coffee.cmd' if process.platform is 'win32'
      serverProc = require('child_process').spawn exec, ['runserver.coffee'],
        stdio: 'inherit'

    if serverProc?
      console.log "trying to kill old server"
      serverProc.on 'close', execServer
      serverProc.kill()
    else
      execServer()

  grunt.registerTask "default", "coffee jade stylus server reload watch"
  grunt.registerTask "compile", "coffee jade stylus"

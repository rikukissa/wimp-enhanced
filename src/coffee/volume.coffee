define (require) ->
  $ = require('jquery') 
  
  mousedown = false

  init: (vmo) ->
    $('.volume-handle').on 'mousedown', -> mousedown = true
    $('.volume-handle').on 'mouseup', -> mousedown = false
    $('.volume-handle').on 'mousemove', () ->
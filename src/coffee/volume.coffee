define (require) ->
  $ = require('jquery') 
  ui = require('ui')
  init: (vmo) ->
    $('.volume-slider').slider
      orientation: 'vertical'
      range: 'min'
      min: 0
      max: 100
      value: vmo.volume()
      slide: (event, ui) ->
        $('#volume').val(ui.value)
        vmo.video.volume = ui.value / 100
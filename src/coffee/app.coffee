
define (require) ->
  $     = require('jquery')
  ko    = require('knockout')
  
  video = document.getElementById 'video'
  cache = []


  class AppViewModel
    constructor: () ->
      @playing = ko.observable(false)
      @progress = ko.observable(0)
      @title = ko.observable('')

      @setTime = (v, e) ->
        video.currentTime =  e.offsetX / $('.progress-info').width() * video.duration
      
      @titleVisible = ko.observable(false)
      
      @showTitle = ->
        @titleVisible(true)
      
        setTimeout () =>
          @titleVisible(false)
        , 3000
      
      @play = () ->
        video.play()
        @playing(true)  
      

      @stop = () ->
        video.pause()
        @playing(false)      
      

      @toggleState = () ->
        if @playing()
          video.pause()
          @playing(false)
        else
          video.play()
          @playing(true)
      

      @next = next



  fetch = (callback = ->) ->
     $.get '/r', (data) ->
      fetched =
        title: $(data).find('.video-title').text()
        source: $(data).find('#video').attr('href')
      cache.push fetched
      callback fetched

  resize = ->
    video.width = $(video).width()
    video.height = $(video).height()   


  set = (v) ->
    $(video).empty().append '<source src="' + v.source + '" type="video/mp4">'
    cache.splice 0, 1
    video.volume = 0.05
    vmo.title(v.title)
    vmo.showTitle()
    vmo.play()
    fetch()
    

  next = ->
    return if cache.length == 0
    set cache[0]

  progress = ->
    vmo.progress video.currentTime / video.duration * 100

  vmo = new AppViewModel()
  ko.applyBindings vmo
  

  main: () -> 
    fetch (v) ->
      set(v)
      resize()
      
      #video.play()
      $(window).on 'resize', resize
      $(video).on 'ended', -> next()
      $(video).on 'timeupdate', -> progress()
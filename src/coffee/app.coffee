
define (require) ->
  $       = require('jquery')
  ko      = require('knockout')
  moment  = require('moment')
  videoVolume = 10
  class AppViewModel
    constructor: () ->
      @video = document.getElementById 'video'
      @video.volume = videoVolume / 100
      @cache = []

    title: ko.observable('')
    volume: ko.observable(videoVolume)
    playing: ko.observable(false)
    duration: ko.observable(0)
    progress: ko.observable(0)
    currentTime: ko.observable(0)
    titleVisible: ko.observable(false)
    volumeVisible: ko.observable(false)

    setTime: (v, e) -> video.currentTime =  e.offsetX / $('.progress').width() * @video.duration
    toggleVolume: () ->
      if @volumeVisible()
        @volumeVisible(false)
      else
        @volumeVisible(true)
    showTitle: ->
      @titleVisible(true)
      setTimeout () =>
        @titleVisible(false)
      , 3000
    
    play: ->
      video.play()
      @playing(true)  
    
    stop: ->
      video.pause()
      @playing(false)      
    
    toggleState: ->
      if @playing()
        video.pause()
        @playing(false)
      else
        video.play()
        @playing(true)
    
    fetch: (callback = ->) ->
      $.get '/r', (data) =>
        fetched =
          title: $(data).find('.video-title').text()
          source: $(data).find('#video').attr('href')
        @cache.push fetched
        callback fetched

    resize: =>
      @video.width = $(@video).width()
      @video.height = $(@video).height()   

    set: (v) ->
      $(@video).empty().append '<source src="' + v.source + '" type="video/mp4">'
      @cache.splice 0, 1
      @title(v.title)
      @showTitle()
      @play()
      @fetch()

    next: =>
      return if @cache.length == 0
      @set @cache[0]

    setProgress: =>
      @progress @video.currentTime / @video.duration * 100
      
      @currentTime Math.round(@video.currentTime)
      @duration Math.round @video.duration
  

  main: () -> 
    vmo = new AppViewModel()
    ko.applyBindings vmo
    vmo.fetch (v) ->
      vmo.set(v)
      vmo.resize()
      
      #video.play()
      require('volume').init(vmo)
      $(window).on 'resize', vmo.resize
      $(video).on 'ended', vmo.next
      $(video).on 'timeupdate', vmo.setProgress
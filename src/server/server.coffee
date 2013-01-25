express = require('express')
module.exports.createServer = () ->
  app     = express()
  request = require('request')
  httpd   = require('http').createServer(app)

  app.use express.static('public')
  app.get '/r', (req, res) ->
    request 
      url: 'http://m.wimp.com/random'
      headers:
        'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
    , (err, response, body) ->
      res.send body

  app.get '*', (req, res) -> res.sendfile('public/index.html')

  return httpd

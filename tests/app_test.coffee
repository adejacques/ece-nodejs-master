app = require '../lib/app'
server = require '../bin/start.js'
should = require 'should'
http = require 'http'

port = 1338
sessionCookie = null

defaultGetOptions = (path) ->
  options =
    host: "localhost"
    port: port
    path: path
    method: "GET"
    headers:
      Cookie: sessionCookie
  options

describe 'app', ->
  before (done) ->
     app.listen(port)
    , (err) ->
      if err
        done err
    , (result) ->
      done

  after (done) ->
    app.close


  it 'should exist', (done) ->
    should.exist(app)
    done()

  it 'should be listening at localhost:1337', (done) ->
    headers = defaultGetOptions '/'
    http.get headers, (res) ->
      res.statusCode.should.eql(404)
      done()

app = require '../lib/app'
should = require 'should'
http = require 'http'

# Test server is started well
describe 'app', ->
  it "should return a 200 response", (done) ->
    app.listen(1337)
    http.get "http://localhost:1337", (res) ->
      res.statusCode.should.eql 200
      done()
      return

  return

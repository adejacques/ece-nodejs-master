app = require '../lib/app'
should = require 'should'
http = require 'http'

# Test server is started well
describe 'app', ->
  # Test app run on correct page
  it "should return a 200 response", (done) ->
    app.listen(1337)
    http.get "http://localhost:1337", (res) ->
      res.statusCode.should.eql 200
      done()
      return

  # Test ask uncorect page return 404
  it "should return a 404 response", (done) ->
    app.listen(1337)
    http.get "http://localhost:1337/testFail", (res) ->
      res.statusCode.should.eql 404
      done()
      return

  return

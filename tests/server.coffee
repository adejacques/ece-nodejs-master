app = require '../lib/app'
server = require '../bin/start.js'
should = require 'should'
http = require 'http'
assert = require("chai").assert;

# Test server is started well
describe 'app', ->
  it "should return a 200 response", (done) ->
    app.listen(1337)
    http.get "http://localhost:1337", (res) ->
      assert.equal res.statusCode, 200
      done()
      return

  return

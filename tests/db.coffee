rimraf = require 'rimraf'
should = require 'should'
db = require '../lib/db'

client = db "#{__dirname}/../db/webappTest", { valueEncoding: 'json' }

describe 'users', ->

  before (next) ->
    rimraf "#{__dirname}/../db/webappTest", next

  after (next) ->
    rimraf "#{__dirname}/../db/webappTest", next

  it 'insert and get all', (next) ->
    client.users.set "myusername",
      password: "mypassword"
      firstname: "myfirstname"
    , (err) ->
      return next err if err
      client.users.get "myusername"
      , (user) ->
        #console.log user
        if typeof(user) is 'object'
          if user.password is not undefined
            user.password.should.eql 'mypassword'

          user.username.should.eql 'myusername'
          user.firstname.should.eql 'myfirstname'
        else
          user.should.eql "end!"
    next()

  it 'get only a single user', (next) ->
    client.users.set "toto",
      password: "ptoto"
      firstname: "Toto"
    , (err) ->
      return next err if err
      client.users.set "totoBis",
        password: "ptotobis"
        firstname: "Toto Bis"
      , (err) ->
        return next err if err
        client.users.get "toto"
        , (user) ->
          console.log user
          if typeof(user) is 'object'
            if user.password is not undefined
              user.password.should.eql 'ptoto'
            user.username.should.eql 'toto'
            user.firstname.should.eql 'Toto'
            should.not.exists user.email
    next()

  it 'get only a single user by mail', (next) ->
    client.emails.set "userA@gm.com",
      username: "userA"
    , (err) ->
      return next err if err
      client.emails.set "userB@gm.com",
        username: "userB"
      , (err) ->
        return next err if err
        client.emails.get "userB@gm.com"
        , (email) ->
          console.log email
          if typeof(email) is 'object'
            email.emailname.should.eql 'userB@gm.com'
            email.username.should.eql 'userB'
    next()

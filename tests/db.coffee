
rimraf = require 'rimraf'
should = require 'should'
db = require '../lib/db'

describe 'users', ->

  beforeEach (next) ->
    rimraf "/tmp/webapp", next

  it 'insert and get', (next) ->
    client = db "/tmp/webapp"
    client.users.set 'wdavidw',
      lastname: 'Worms'
      firstname: 'David'
      email: 'david@adaltas.com'
    , (err) ->
      return next err if err
      client.users.get 'wdavidw', (err, user) ->
        return next err if err
        user.username.should.eql 'wdavidw'
        user.lastname.should.eql 'Worms'
        client.close()
        next()

  it 'get only a single user', (next) ->
    {users} = db "/tmp/webapp"
    users.set 'wdavidw',
      lastname: 'Worms'
      firstname: 'David'
    , (err) ->
      return next err if err
      users.set 'toto',
        lastname: 'Toto'
        firstname: 'My'
        email: 'toto@adaltas.com'
      , (err) ->
        return next err if err
        users.get 'wdavidw', (err, user) ->
          return next err if err
          user.username.should.eql 'wdavidw'
          user.lastname.should.eql 'Worms'
          should.not.exists user.email
          next()

describe 'usersMail', ->
  it 'insert mail and get', (next) ->
    client = db "/tmp/webapp2"
    client.emails.set 'mail@gmail.com',
      password: 'mdp'
      username: 'mailTest'
      email: 'mail@gmail.com'
    , (err) ->
      return next err if err
      client.users.get 'mail@gmail.com', (err, user) ->
        return next err if err
        user.password.should.eql 'mdp'
        user.username.should.eql 'mailTest'
        client.close()
        next()

  it 'get only a single user by mail', (next) ->
    {users_by_email} = db "/tmp/webapp2"
    users.set 'mail@gmail.com',
      password: 'mdp'
      username: 'mailTest'
    , (err) ->
      return next err if err
      users.set 'toto@gmail.com',
        password: 'mdp_toto'
        username: 'toto'
      , (err) ->
        return next err if err
        users.get 'mail@gmail.com', (err, user) ->
          return next err if err
          user.password.should.eql 'mdp'
          user.username.should.eql 'mailTest'
          next()

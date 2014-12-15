level = require 'level'

module.exports = (db="#{__dirname}../db") ->
  db = level db if typeof db is 'string'
  close: (callback) ->
    db.close callback
  users:
    get: (username, callback) ->
      user = {}
      db.createReadStream
        gt: "users:#{username}:"
      .on 'data', (data) ->
        [_, username, key] = data.key.split ':'
        user.username ?= username
        user[key] = data.value
        if user.username is username
          callback user
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
      .on 'end', ->
        callback 'end!'
    getPassword: (username, callback) ->
      user = {}
      db.createReadStream
        gt: "users:#{username}:"
      .on 'data', (data) ->
        [_, username, key] = data.key.split ':'
        user.username ?= username
        user[key] = data.value
        if user.username is username and key is "password"
          console.log key
          callback user
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
      .on 'end', ->
        callback 'end!'
    getAll: (callback) ->
      pers = {}
      output = []
      db.createReadStream
       gt: ""
      .on 'data', (data) ->
        [_,data_key,_] = data.key.split ':'
        pers.key = data_key
        pers.value = data.value
        test = [data_key, data.value]
        output.push test
      .on 'end', ->
        callback output
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
    set: (username, user, callback) ->
      ops = for k, v of user
        continue if k is 'username'
        type: 'put'
        key: "users:#{username}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err if callback and typeof (callback) is "function"
    del: (username, callback) ->
      # TODO
  emails:
    get: (emailname, callback) ->
      users_by_email = {}
      db.createReadStream
        gt: "users_by_email:#{emailname}:"
      .on 'data', (data) ->
        [_, emailname, key] = data.key.split ':'
        users_by_email.emailname ?= emailname
        users_by_email[key] = data.value
        if users_by_email.emailname is emailname
          callback users_by_email
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
      .on 'end', ->
        callback 'end!'
    set: (emailname, users_by_email, callback) ->
      ops = for k, v of users_by_email
        continue if k is 'emailname'
        type: 'put'
        key: "users_by_email:#{emailname}:#{k}"
        value: v
       db.batch ops, (err) ->
         callback err if callback and typeof (callback) is "function"

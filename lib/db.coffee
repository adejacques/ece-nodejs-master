level = require 'level'

module.exports = (db="#{__dirname}../db") ->
  db = level db if typeof db is 'string'
  close: (callback) ->
    db.close callback
  users:
    get: (username, callback) ->
      user = {}
      global.user1 = {}
      username1 = username
      password = ""
      #console.log "username : #{username}"
      db.createReadStream
        gt: "users:#{username}:"
      .on 'data', (data) ->
        [_, username, key] = data.key.split ':'
        user.username = username
        user[key] = data.value
        password = user.password
        #console.log password
        if username1 is user.username and user.password is password#"azerty"
          user1 = user
          callback user1
          #console.log user1
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
          #console.log key
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
        [type,data_key,key] = data.key.split ':'
        if key != "logs"
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
  logs:
    set: (username, logs_by_username, callback) ->
      ops = for k, v of logs_by_username
        continue if k is 'username'
        console.log "key :" + k + "value : " + v
        console.log "logs_by_username:#{username}:#{k}"
        type: 'put'
        key: "logs_by_username:#{username}:#{k}"
        value: v
       db.batch ops, (err) ->
         callback err if callback and typeof (callback) is "function"
    get: (username, callback) ->
      logs_by_username = {}
      db.createReadStream
        gt: "logs_by_username:#{username}:"
      .on 'data', (data) ->
        [_, username, key] = data.key.split ':'
        logs_by_username.username ?= username
        logs_by_username[key] = data.value
        if logs_by_username.username is username
          callback logs_by_username
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
      .on 'end', ->
        callback 'end!'

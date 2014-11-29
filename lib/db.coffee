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
        # console.log "password : #{data.value}"
        # console.log "username : #{username}"
        # console.log '----------------------'
        if user.username is username
          callback user
      .on 'error', (err) ->
        callback err if callback and typeof (callback) is "function"
      .on 'end', ->
        callback 'end!'
    set: (username, user, callback) ->
      ops = for k, v of user
        continue if k is 'username'
        type: 'put'
        key: "users:#{username}:#{k}"
        value: v
      console.log "valeur de k : #{k}"
      console.log "valeur key dans le set : #{username}"
      console.log "valeur password dans le set : #{v}"
      db.batch ops, (err) ->
        callback err if callback and typeof (callback) is "function"
    del: (username, callback) ->
      # TODO

fs = require "fs"
db = require "../lib/db"
parse = require "csv-parse"
JSONStream = require "JSONStream"
es = require "event-stream"

parser = parse(delimiter: ";")

output = []
myformat = "csv"

source = fs.createReadStream(__dirname + "/../public/resources/users.csv")

module.exports = (client, format) ->
  myClient = client
  myformat = format if format
  # Catch error read file
  source.on "error", ->
    console.log "[ERROR] " + error.message
    return

  # Catch error password
  parser.on "error", (err) ->
    console.log "[ERROR] " + err.message
    return

  # Save record in output during readable action
  parser.on "readable", ->
    while record = parser.read()
      #console.log record
      #output.push record
      registerUser record
    return

  # Function get stream if it is json format
  getStream = ->
    jsonData = __dirname + "/../public/resources/export.json"
    stream = fs.createReadStream(jsonData,encoding: "utf8")
    parserJson = JSONStream.parse("*")
    stream.pipe parserJson

  # Function to save users in db
  registerUser = (myuser) ->
    ###
      myuser[0] username
      myuser[1] mail
      myuser[2] password
      myuser[3] firstname
      myuser[4] lastname
    ###
    myClient.users.get myuser[0]
    , (user) ->
      if user.username is myuser[0]
        console.log 'already register'
      else
         myClient.users.set myuser[0],
           password: myuser[2]
           firstname: myuser[3]
           lastname: myuser[4]
         , (err) ->
           console.log 'error set user:' + err if err
         myClient.emails.set myuser[1],
           username: myuser[0]
         , (err) ->
            console.log 'error set mail:' + err if err
        myClient.emails.get myuser[1]
        , (email) ->
           console.log email
        myClient.users.get myuser[0]
        , (user) ->
            console.log user
    return

  # Do pipe, import function
  importUser: () ->
    console.log 'import user call'
    if format is "json"
      getStream().pipe es.mapSync((data) ->
        #console.log(data);
        i = 0
        while i < data.length
          console.log "user " + i + " : "
          dataStore = [data[i].username, data[i].email, data[i].password, data[i].firstname, data[i].lastname]
          registerUser dataStore
          i++
        return
      )
    else
      source.pipe parser
    return

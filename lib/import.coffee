fs = require "fs"
parse = require "csv-parse"
parser = parse(delimiter: ";")
source = fs.createReadStream(__dirname + "/../public/resources/users.csv")
output = []
db = require "../lib/db"

module.exports = (client, format) ->
  myClient = client

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
      #output.push record
      registerUser record
    return

  # Function to save user in db
  registerUser = (myuser) ->
    ###
      myuser[0] username
      myuser[1] mail
      myuser[2] password
      myuser[3] firstname
      myuser[4] lastname
    ###
    #console.log "username: " + myuser[0] + " - mail: " + myuser[1] + " - password: " + myuser[2]

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

  # Do pipe
  importUser: () ->
    console.log 'import user call'
    if format is "csv"
      source.pipe parser
    else
      source.pipe.parser
    return

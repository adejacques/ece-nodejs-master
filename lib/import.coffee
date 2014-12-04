fs = require "fs"
parse = require "csv-parse"
parser = parse(delimiter: ";")
source = fs.createReadStream(__dirname + "/../public/resources/users.csv")
output = []
db = require "../lib/db"

module.exports = (client) ->
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
    output.push record  while record = parser.read()
    return

  # Function to save user in db
  registerUser = (myuser) ->
    ###
      myuser[0] username
      myuser[1] mail
      myuser[2] password
    ###
    #console.log "username: " + myuser[0] + " - mail: " + myuser[1] + " - password: " + myuser[2]

    myClient.users.get myuser[0]
    , (user) ->
      if user.username is myuser[0]
        console.log 'already register'
      else
         myClient.users.set myuser[0],
           password: myuser[2]
         , (err) ->
           console.log 'error set user:' + err if err
         myClient.emails.set myuser[1],
           username: user[0]
         , (err) ->
            console.log 'error set mail:' + err if err
        myClient.emails.get myuser[1]
        , (email) ->
           console.log 'check email:' + email
        myClient.users.get myuser[0]
        , (user) ->
            console.log 'check user:' + user
    return

  # When parser are done, save in database user
  parser.on "finish", ->
    i = 0

    while i < output.length
      myuser = output[i]
      registerUser  myuser
      ++i
    return

  # Do pipe
  importUser: () ->
    console.log 'import user call'
    source.pipe parser
    return


###
TODO
Add package.json
csv-parse
csv-stringify

pipe: process.stdout ==> notre sortie, mettre après en sortie pour leveldb (par défaut dans node)

Doc: nodejs.org/api/stream#stream_class_stream_writable

Implementer :
_write() => implémente logique de quand reçoit les données pour lui dire stop j'en est trop => gestion du buffer
(95% du boulot)

TODO Next week
BUT
csv en entrée avec les utilisateurs, les writes dans levelds (remplace script pour mettre)
implémenter prend le flux et appelle set de levelds pour ajouter les utilisateurs
Script d'import & d'export
=> implémenter readable & writable

En gros:
=> lire csv --> add dans la bdd
=> et inversement --> lis de la bdd et écrit dans csv
###

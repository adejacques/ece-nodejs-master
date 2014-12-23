http = require 'http'
stylus = require 'stylus'
nib = require 'nib'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
methodOverride = require 'method-override'
session = require 'express-session'
errorhandler = require 'errorhandler'
dojo = require 'connect-dojo'
coffee = require 'connect-coffee-script'
serve_favicon = require 'serve-favicon'
serve_index = require 'serve-index'
serve_static = require 'serve-static'
jquery = require 'jquery'
db = require "../lib/db"
rimraf = require 'rimraf'
should = require 'should'

myimport = require "../lib/import"
myexport = require "../lib/export"

mySocket = []
# config = require '../conf/hdfs'

app = express()

###
  INITIALISE SOCKET
###
server = http.Server(app)
io = require('socket.io')(server)

io.on 'connection', (socket) ->
  mySocket.push socket


app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use serve_favicon "#{__dirname}/../public/favicon.ico"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser 'toto'
app.use methodOverride '_method'
app.use session(
  secret: 'toto'
  resave: true
  saveUninitialized: true
)

app.use coffee
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  bare: true
app.use stylus.middleware
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  compile: (str, path) ->
    stylus(str)
    .set('filename', path)
    .set('compress', config?.css?.compress)
    .use nib()
app.use serve_static "#{__dirname}/../public"

###
  USE SOCKET LOGS
###
app.use (req,res,next) ->
  req.session.count ?= 0
  req.session.count++
  req.session.history ?= []
  req.session.history.push req.url
  req.session.history.push Date.now()

  if typeof req.session.username isnt "undefined"
    client.logs.set req.session.username,
      logs: req.session.history

  for socket , i in mySocket
    socket.emit 'logs',
      username: req.session.username or "anonymous"
      count: req.session.count
      url: req.url
  next()

###
  VARIABLES
###
global.client = db "#{__dirname}/../db/webapp1", { valueEncoding: 'json' }
isAlreadyImport = false

###
  ROUTING
###

## Route get "/"
app.get '/', (req, res, next) ->
  # Import user csv to populate bdd if it is not already done (in case of reload page)
  importFunction()

  sess = req.session
  if sess.username
    #console.log(sess.username)
    #res.status(200)
    #console.log req
    #console.log res
    #res.render 'index', {title: 'My app', isConnect: true}#

    # Add socket io message login
    for socket, i in mySocket
      socket.emit 'reload',
        username: req.session.username or "anonymous"

    #res.render 'index', {title: 'My app', isConnect: false}
  else
    res.render 'index', {title: 'My app', isConnect: false}

  return

## Route post "/login"
app.post '/login', (req, res, next) ->
  sess = req.session
  isRightUser = false

  # If user click on login
  if req.body.button is 'Login'
    client.emails.get req.body.username
    , (email) ->
        # Check with email
        if email.emailname is req.body.username
          client.users.getPassword email.username
          , (user) ->
            if user.password is req.body.password
              #  isRightUser = true
              sess.username = req.body.username

              # Add socket io message login
              for socket, i in mySocket
                socket.emit 'login',
                  username: req.session.username or "anonymous"
                  crdate: Date.now()
                  count: req.session.count
                  url: req.session.history

              res.json
                 mode: 'login'
                 success: true
                 username: req.body.username
                 password: req.body.password
            else
             res.json
               mode: 'login'
               success:false
         else
           # Check with username
           client.users.getPassword req.body.username
           , (user) ->
              if user.username is req.body.username and user.password is req.body.password
                sess.username = req.body.username
                req.session.username = req.body.username

                # Add socket io message login
                for socket, i in mySocket
                  socket.emit 'login',
                    username: req.session.username or "anonymous"
                    crdate: Date.now()
                    count: req.session.count
                    url: req.session.history

                res.json
                  mode: 'login'
                  success: true
                  username: req.body.username

              else
                res.json
                  mode: 'login'
                  success:false

  else if req.body.button is 'Signup'
    # Else if user click on sign up button, display signup form
    res.json
      mode: 'signup'

  else if req.body.button is 'SignupAndLog'
    # Else if user has fill fields sign up and click to save and log
    passwordOk = false;
    error = '';

    # Function to check is password is fill and if it is the same in both case
    verification = ->
      if req.body.username is "" or req.body.email is "" or req.body.password is "" or req.body.repassword is ""
        passwordOk = false
        error = 'fieldsEmpty'
      else if req.body.password is req.body.repassword
        passwordOk = true
      else
        error = 'passwordNotOk'

    #Do verification
    if passwordOk is true
      client.users.set req.body.username,
        password: req.body.password
        firstname: req.body.firstname
      , (err) ->
       console.log "error set user" if err
      client.emails.set req.body.email,
        username: req.body.username
      , (err) ->
       console.log "error set mail" if err
       client.emails.get req.body.email
       , (email) ->
          console.log "error get mail" if err
      client.users.get req.body.username
      , (user) ->
        if user.username is req.body.username
          res.json
             mode: 'signupAndLog'
             success: false
        else
           client.users.set req.body.username,
             password: req.body.password
             firstname: req.body.firstname
             lastname: req.body.lastname
           , (err) ->
             console.log 'erreur set' if err
           client.emails.set req.body.email,
             username: req.body.username
           , (err) ->
             console.log 'erreur set' if err
           client.emails.get req.body.email
           , (email) ->
              console.log email
           client.users.get req.body.username
           , (user) ->
               #console.log user
               if user.username is req.body.username and user.password is req.body.password
                 res.json
                   mode: 'signupAndLog'
                   success: true
                   username: req.body.username
                   password: req.body.password
    else if passwordOk is false
      res.json
        mode: 'signupAndLog'
        success: error

## Routes post '/export' to export user in database
app.post '/export', (req, res, next) ->
  exportFunction()
  res.json
    mode: 'export'
    success: true

## Routes post '/logout' to logout
app.post '/logout', (req, res, next) ->
  req.session.destroy()
  res.redirect '/'

## Routes post '/admin' to show logs of user and store
app.post '/admin', (req, res, next) ->
  client.logs.get req.session.username
  , (logs) ->
    if logs.username is req.session.username and typeof logs.password is "undefined"
      #console.log logs
      res.json
        username: req.session.username
        logs: logs.logs

## Routes post "/user/login"
app.post '/user/login', (req, res, next) ->
  res.json
    username: 'wdavidw'
    lastname: 'Wormss'
    Firstname: 'David'
    email: 'david@adaltas.com'

###
 Function export user store in database into csv
###
exportFunction = ->
  output = []

  client.users.getAll (outputBdd) ->
    #halfSize = outputBdd.length / 2
    i = 0
    j = outputBdd.length/4
    max = outputBdd.length - j
    #console.log 'max:'+max+' j:'+j
    console.log outputBdd
    while i < max
      #console.log outputBdd[i]
      username = outputBdd[i][0]
      lastname = outputBdd[i][1]
      firstname = outputBdd[i+1][1]
      password = outputBdd[i+2][1]
      console.log "user:" + username + " pass:"+password+" firstn:"+firstname+" lastn:"+lastname

      while j < outputBdd.length
        console.log j + ":"+ outputBdd[j]
        #if typeof(outputBdd[j]) is not "undefined"
        if username is outputBdd[j][1]
          output.push [
            username
            outputBdd[j][0]
            password
            firstname
            lastname
          ]
          break
        j++

      i = i+3
      j = outputBdd.length/4

    expt = myexport output
    expt.exportUser()

  return

###
 Function import user store in csv into database if it is not already done
###
importFunction = ->
  unless isAlreadyImport
    imt = myimport client
    imt.importUser()
    isAlreadyImport = true
  return

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()

#module.exports = app
module.exports = server

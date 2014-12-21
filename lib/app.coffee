
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


app.use (req,res,next) ->
  req.session.count ?= 0
  req.session.count++
  req.session.history ?= []
  req.session.history.push req.url

  for socket , i in mySocket
    socket.emit 'logs',
      username: req.session.username or "anonymous"
      count: req.session.count
      url: req.url
  next()


# declare variables
global.client = db "#{__dirname}/../db/webapp1", { valueEncoding: 'json' }
isAlreadyImport = false

# routing
app.get '/', (req, res, next) ->
  # Import user csv to populate bdd if it is not already done (in case of reload page)
  importFunction()
  sess = req.session
  if sess.username
    console.log(sess.username)
    res.status(200)
  else
    res.render 'index', title: 'My app'
  return

app.post '/login', (req, res, next) ->
  console.log req.body
  sess = req.session
  isRightUser = false
  #TODO TEST Return True or false
  if req.body.button is 'Login'
    #Login user
    client.emails.get req.body.username
    , (email) ->
        console.log "mail"
        console.log email
        console.log req.body.username
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
           client.users.getPassword req.body.username
           , (user) ->
              console.log "user"
              console.log user
              if user.username is req.body.username and user.password is req.body.password
                sess.username = req.body.username
                req.session.username = req.body.username

                # Add socket io message login
                for socket, i in mySocket
                  socket.emit 'login',
                    username: req.session.username or "anonymous"
                    crdate: Date.now()

                res.json
                  mode: 'login'
                  success: true
                  username: req.body.username
                    #password: req.body.password
              else
                res.json
                  mode: 'login'
                  success:false

  else if req.body.button is 'Signup'
    #Change to signup form
    res.json
      mode: 'signup'
  else if req.body.button is 'SignupAndLog'
    passwordOk = false;
    error = '';

    verification = ->
      if req.body.username is "" or req.body.email is "" or req.body.password is "" or req.body.repassword is ""
        passwordOk = false
        error = 'fieldsEmpty'
      else if req.body.password is req.body.repassword
        passwordOk = true
      else
        error = 'passwordNotOk'
    #Signup and login
    #res.json
      #mode: 'signupAndLog'
    do verification
    console.log "error : " + error
    if passwordOk is true
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
               console.log user
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


app.post '/export', (req, res, next) ->
  console.log 'export bdd button function app'
  #Signup and login
  exportFunction()
  res.json
    mode: 'export'
    success: true

app.post '/logout', (req, res, next) ->
  console.log("logout post")
  req.session.destroy()
  #res.send('You are logged out ! <meta http-equiv="refresh" content="5; URL=/">')
  res.redirect '/'

# Function export import
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

    expt = myexport output
    expt.exportUser()

  return

importFunction = ->
  unless isAlreadyImport
    imt = myimport client
    imt.importUser()
    isAlreadyImport = true
  return


app.post '/user/login', (req, res, next) ->
  res.json
    username: 'wdavidw'
    lastname: 'Wormss'
    Firstname: 'David'
    email: 'david@adaltas.com'

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()

#module.exports = app
module.exports = server

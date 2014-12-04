
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

# config = require '../conf/hdfs'

app = express()

app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use serve_favicon "#{__dirname}/../public/favicon.ico"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser 'toto'
app.use methodOverride '_method'
app.use session secret: 'toto', resave: true, saveUninitialized: true

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

# declare variables
global.client = db "./db/webapp1", { valueEncoding: 'json' }
isAlreadyImport = false

# routing
app.get '/', (req, res, next) ->
  # Import user csv to populate bdd if it is not already done (in case of reload page)
  unless isAlreadyImport
    imt = myimport client
    imt.importUser()
    isAlreadyImport = true

  res.render 'index', title: 'Express'

app.post '/login', (req, res, next) ->
  console.log req.body
  #TODO TEST Return True or false
  if req.body.button is 'Login'
    client.emails.get req.body.username
    , (email) ->
        console.log email
        console.log req.body.username
        if email.emailname is req.body.username
          client.users.get email.username
          , (user) ->
            if user.password is req.body.password
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
           client.users.get req.body.username
           , (user) ->
              console.log user
              if user.username is req.body.username and user.password is req.body.password
                res.json
                  mode: 'login'
                  success: true
                  username: req.body.username
                  password: req.body.password
              else
                res.json
                  mode: 'login'
                  success:false

  else if req.body.button is 'Signup'
    #Change to signup form
    res.json
      mode: 'signup'
  else if req.body.button is 'SignupAndLog'
    client.users.get req.body.username
    , (user) ->
      if user.username is req.body.username
        res.json
           mode: 'signupAndLog'
           success: false
      else
         client.users.set req.body.username,
           password: req.body.password
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

app.post '/user/login', (req, res, next) ->
  res.json
    username: 'wdavidw'
    lastname: 'Wormss'
    Firstname: 'David'
    email: 'david@adaltas.com'

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()

module.exports = app

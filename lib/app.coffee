
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
db = require("./db.coffee")
rimraf = require 'rimraf'
should = require 'should'

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

app.get '/', (req, res, next) ->
  res.render 'index', title: 'Express'

global.client = db "/tmp/webapp1"

app.post '/login', (req, res, next) ->
  if req.body.button is 'Login'
    client.users.get req.body.username
    , (user) ->
        console.log user
        #if (user.username is req.body.username or user.mail is req.body.mail) and user.password is req.body.password
        if user.username is req.body.username and user.password is req.body.password
          #TODO Check with mail or username
          #User login password and username is ok
          res.json
            mode: 'login'
            success: true
            username: req.body.username
            password: req.body.password
        else
          #User login password or username is wrong
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
      #if user.username is req.body.username or user.mail is req.body.mail
      if user.username is req.body.username
        #TODO Check with mail or username
        #Already register stay in this form and display error message
        res.json
           mode: 'signupAndLog'
           success: false
      else
        #TODO Store mail
        #Store and log username
         client.users.set req.body.username,
           password: req.body.password
           #mail: req.body.mail
         , (err) ->
           console.log 'erreur set'
         client.users.get req.body.username
         , (user) ->
             console.log user
             #if (user.username is req.body.username or user.mail is req.body.mail) and user.password is req.body.password
             if user.username is req.body.username and user.password is req.body.password
               res.json
                 mode: 'signupAndLog'
                 success: true
                 username: req.body.username
                 password: req.body.password
             #else
               #res.json
               #mode: 'login'
               #success:false
     ###
     client.users.get req.body.username
     , (user) ->
       if user.username is req.body.username
         res.json
            mode: 'signup'
            success: false
            reason: 'already in database'
       else
          client.users.set req.body.username,
            password: req.body.password
          , (err) ->
            console.log 'erreur set'
          client.users.get req.body.username
          , (user) ->
              console.log user
              if user.username is req.body.username and user.password is req.body.password
                res.json
                  mode: 'signup'
                  success: true
                  username: req.body.username
                  password: req.body.password
              else
                res.json
                success:false
      ###

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

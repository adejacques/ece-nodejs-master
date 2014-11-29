
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

global.client = db "/tmp/webapp2"

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

app.post '/login', (req, res, next) ->
  #client = db "/tmp/webapp1"
  client.users.get req.body.username
  , (user) ->
      console.log "user:"+ user
      #tmp = user.username is req.body.username or user.mail is req.body.username
      #console.log "tmp:"+tmp
      if user.username is req.body.username and user.password is req.body.password
        console.log 'Connected !'
        res.json
          success: true
          #username: user.username
          #mail: user.mail
          #password: user.password
          username: req.body.username
          password: req.body.password
      else
        console.log 'Not connected !'
        res.json
          success:false
  , (err) ->
    console.log 'erreur get'

app.post '/user/login', (req, res, next) ->
  res.json
    username: 'wdavidw'
    lastname: 'Wormss'
    Firstname: 'David'
    email: 'david@adaltas.com'

app.get '/signup', (req, res, next) ->
  res.render 'signup', title: 'Express'

app.post '/signup', (req, res, next) ->
  client.users.get req.body.username
  , (user) ->
      #or user.mail is req.body.mail
      if user.username is req.body.username
        console.log 'Already register'
        res.json
          success: false
      else
        console.log 'Need register'

        client.users.set req.body.username,
          password: req.body.password
        , (err) ->
          console.log 'erreur set'
        res.json
          success: true
  , (err) ->
    console.log 'erreur get'

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()

module.exports = app

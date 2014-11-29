
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

app.post '/login', (req, res, next) ->
  #TODO TEST Return True or false
  client = db "/tmp/webapp1"
  client.users.set req.body.username,
    password: req.body.password
  , (err) ->
    console.log 'erreur set'
    client.users.get req.body.username
    , (user) ->
        console.log user
        if user.username is req.body.username and user.password is req.body.password
          console.log 'login réussi'
          res.json
            success: true
            username: req.body.username
            password: req.body.password
        else
          console.log 'login raté'
          res.json
            success:false
    , (err) ->
      console.log 'erreur get'
  client.close

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

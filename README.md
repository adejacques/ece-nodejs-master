# ECE PROJECT
This is a node.js project for Asynchronous Server Technologies (ECE Paris course).

## Description
Use REST server and level database to create web application. This site allow user to signup and signin with username or mail in order to display and analyse Forex Market graph.

## Functionalities

* Sign in form  accept username and email
* Sign up form (username, email, password, firstname, lastname)
* Validation server and client (AJAX, Pretty display and message)
* Import / Export (csv + json)

## Technology
* [Express.js](http://expressjs.com/)
* [npm](https://www.npmjs.org/)
* [Node.js](http://nodejs.org/)
* [CoffeeScript](http://coffeescript.org/)
* [LevelDB](http://leveldb.org/)
* [Mocha](http://mochajs.org/)
* [JADE](http://jade-lang.com/)
* [Stylus](http://learnboost.github.io/stylus/)
* [Bootstrap](http://getbootstrap.com/)

## Layout
```
.
├── bin                   # executable
|   └── start.js          # start the application
|   └── import.js         # start import
|   └── export.js         # start export
├── db                    # database components
├── lib                   # core components
|   ├── app.coffee        # main file of the application
|   ├── db.coffee         # module database implements levelDB
|   ├── export.coffee     # module export
|   └── import.coffee     # module import
├── public                # web root
├── test                  # test component
├── views                 # JADE templates
├── .git                  # git config
├── .gitignore            # Git ignore  
├── package.json          # Content module express & npm
├── README.md             # Read me
└── License.md            # License
```
## LevelDB schema
User namespace key: "users:#{username}:#{property}:" properties: "lastname", "firstname", "email" and "password"
Email namespace key: "users:#{username}:#{property}:" properties: "email"

## Installation & run

### Install
Clone this repesitory.

Install [node.js](http://nodejs.org/).
Install dependencies declare in package.json
```bash
npm install
```
### Run main application
With bash, go to home project directory.

Start server
```bash
node bin/start.js
```
Go to browser
http://localhost:1337/

### Run import
With bash, go to home project directory.
```bash
node bin/import [--help] [--format {name}]
```

### Run export
With bash, go to home project directory.
```bash
node bin/export [--help] [--format {name}]
```

### Run test
With bash, go to home project directory.

Run test
```bash
npm test
```

## Contributors (groupe 07)
* Alexandre Dejacques : <dejacques@ece.fr> - <https://github.com/adejacques>
* Lauren Letestu : <letestu@ece.fr> - <https://github.com/lletestu>
* Thomas Pansart : <pansart@ece.fr> - <https://github.com/tpansart>

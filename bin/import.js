#!/usr/local/bin/node



/*
var fs = require('fs');
var parse = require('csv-parse');
//var csv = require('csv');
//var transform = require('stream-transform');
var parser = parse({delimiter:';'});
var source = fs.createReadStream(__dirname + '/../public/resources/users.csv')

var output = [];

// Catch error read file
source.on('error', function(){
  console.log('[ERROR] ' + error.message);
});

// Catch error password
parser.on('error', function(err){
  console.log('[ERROR] ' + err.message);
});

// Save record in output during readable action
parser.on('readable', function(){
  while(record = parser.read()){
    output.push(record);
  }
});

// When parser are done, save in database user
parser.on('finish', function(){
  console.log("done: \n");
  for (var i = 0; i < output.length; ++i) {
    var user = output[i];
    saveUser(user);
  }

});

// Save in db
function saveUser(user) {
  console.log("username: " + user[0] + " - mail: " + user[1] + " - password: " + user[2]);
}

// Call pipe function
//source.pipe(parser).pipe(csv.stringify()).pipe(process.stdout);
source.pipe(parser);
*/

/* ------- TEST ------- */
/*
var csv = require('csv');

csv.generate({seed: 1, columns: 2, length: 20})
.pipe(csv.parse())
.pipe(csv.transform(function(record){
  return record.map(function(value){
    return value.toUpperCase()
  });
}))
.pipe(csv.stringify ())
.pipe(process.stdout);
*/

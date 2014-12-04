#!/usr/local/bin/node
var fs = require('fs');
// Flag 'a' append at the end
var wstream = fs.createWriteStream(__dirname + '/../public/resources/users.csv', {'flags': 'a'});
// Flag 'w' remove all and write
//var wstream = fs.createWriteStream(__dirname + '/../public/resources/users.csv', {'flags': 'w'});
var stringify = require('csv-stringify');
var csv = require('csv');

var stringifier = stringify({delimiter: ';'})
var data = '';

// Catch error stringifier
stringifier.on('error', function(err){
  consol.log(err.message);
});

// Adding data during readable
stringifier.on('readable', function(){
  while(row = stringifier.read()){
    data += row;
  }
});

// Write on csv file at the end
stringifier.on('finish', function(){
  console.log('end:'+data);
  wstream.write(data);
});


var arr = [[ "blup","blup@ece.fr","blup"], [ "blouip","blouip@ece.fr","blouip"]];

for (var i = 0; i<arr.length; i++) {
  stringifier.write(arr[i]);
}

stringifier.end();
wstream.end();

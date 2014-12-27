require('coffee-script/register')

var myimport = require('../lib/import');
var db = require('../lib/db');
var argv = require('minimist')(process.argv.slice(2));
var format = "csv";

var client = db("" + __dirname + "/../db/webapp1", {
  valueEncoding: 'json'
});

/*
Import function call import coffee
*/
var importFunction = function(format) {
  var imt = myimport(client, format);
  imt.importUser();
};

/*
If argv help show help
*/
if (argv.help) {
  console.log("\n\Import function\nCommand : import [--help] [--format {name}]\n--help : show help\n--format : csv (default) or json\n\n");
}

/*
If argv format call import function
*/
if (argv.format) {
  if (argv.format === 'json') {
    // Export to json
    format = "json";
  }
}
importFunction(format);

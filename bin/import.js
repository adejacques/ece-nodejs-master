require('coffee-script/register')

var myimport = require('../lib/import');
var db = require('../lib/db');
var argv = require('minimist')(process.argv.slice(2));

var client = db("" + __dirname + "/../db/webapp1", {
  valueEncoding: 'json'
});

var importFunction = function() {
  var imt = myimport(client);
  imt.importUser();
};

if (argv.help) {
  console.log("\n\Import function\nCommand : import [--help] [--format {name}]\n--help : show help\n--format : csv (default) or json\n\n");
}

if (argv.format) {
  console.log(argv.format);
  if (argv.format === 'json') {
    // Export to json
  } else {
    // Default export to csv
    importFunction();
  }
}

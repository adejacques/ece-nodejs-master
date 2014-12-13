require('coffee-script/register')

var myexport = require('../lib/export');
var db = require('../lib/db');
var argv = require('minimist')(process.argv.slice(2));

var client = db("" + __dirname + "/../db/webapp1", {
  valueEncoding: 'json'
});

var exportFunction = function() {
  var output;
  output = [];
  client.users.getAll(function(outputBdd) {
    var expt, halfSize, i, j;
    halfSize = outputBdd.length / 2;
    i = 0;
    console.log(outputBdd);
    while (i < halfSize) {
      j = halfSize;
      while (j < outputBdd.length) {
        if (outputBdd[i][0] === outputBdd[j][1]) {
          output.push([outputBdd[i][0], outputBdd[j][0], outputBdd[i][1]]);
          break;
        }
        j++;
      }
      i++;
    }
    console.log(output)
    expt = myexport(output);
    return expt.exportUser();
  });
};

if (argv.help) {
  console.log("\n\nExport function\nCommand : export [--help] [--format {name}]\n--help : show help\n--format : csv (default) or json\n\n");
}

if (argv.format) {
  console.log(argv.format);
  if (argv.format === 'json') {
    // Export to json
  } else {
    // Default export to csv
    exportFunction();
  }
}

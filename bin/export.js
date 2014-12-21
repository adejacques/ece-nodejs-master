require('coffee-script/register')

var myexport = require('../lib/export');
var db = require('../lib/db');
var argv = require('minimist')(process.argv.slice(2));

var client = db("" + __dirname + "/../db/webapp1", {
  valueEncoding: 'json'
});

var exportFunction = function(format) {
  var output, firstname, i, j, lastname, max, password, username;
  output = [];
  console.log("ex");
  client.users.getAll(function(outputBdd) {

    /*var expt, halfSize, i, j;
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
    }*/
    i = 0;
    j = outputBdd.length / 4;
    max = outputBdd.length - j;

    while (i < max) {
      username = outputBdd[i][0];
      lastname = outputBdd[i][1];
      firstname = outputBdd[i + 1][1];
      password = outputBdd[i + 2][1];
      console.log("user:" + username + " pass:" + password + " firstn:" + firstname + " lastn:" + lastname);
      while (j < outputBdd.length) {
        console.log(j + ":" + outputBdd[j]);
        if (username === outputBdd[j][1]) {
          output.push([username, outputBdd[j][0], password, firstname, lastname]);
          break;
        }
        j++;
      }
      i = i + 3;
    }
    console.log("out");
    console.log(output);
    expt = myexport(output, format);
    return expt.exportUser();
  });
};

if (argv.help) {
  console.log("\n\nExport function\nCommand : export [--help] [--format {name}]\n--help : show help\n--format : csv (default) or json\n\n");
}

if (argv.format) {
  var format = "csv";
  if (argv.format === 'json') {
    // Export to json
    format = "json";
  }
  console.log(format);
  exportFunction(format);
}

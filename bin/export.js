require('coffee-script/register')

var myexport = require('../lib/export');
var db = require('../lib/db');
var argv = require('minimist')(process.argv.slice(2));

var client = db("" + __dirname + "/../db/webapp1", {
  valueEncoding: 'json'
});

/*
Export function call export coffee
*/
var exportFunction = function(format) {
  var output, firstname, i, j, lastname, max, password, username;
  output = [];
  client.users.getAll(function(outputBdd) {

    i = 0;
    j = outputBdd.length / 4;
    max = outputBdd.length - j;
    console.log(outputBdd);
    console.log("i:"+i+" j:"+j+" max:"+max);
    while (i < max) {
      username = outputBdd[i][0];
      lastname = outputBdd[i][1];
      firstname = outputBdd[i + 1][1];
      password = outputBdd[i + 2][1];
      console.log("user:" + username + " pass:" + password + " firstn:" + firstname + " lastn:" + lastname);
      while (j < outputBdd.length) {
        console.log(j + ":" + outputBdd[j]);
        if (username === outputBdd[j][1]) {
          if (format == "json") {
            var item = {
              "username": username,
              "email": outputBdd[j][0],
              "password": password,
              "firstname": firstname,
              "lastname": lastname
            };

            output.push(item);

          } else {
            output.push([username, outputBdd[j][0], password, firstname, lastname]);
          }
          break;
        }
        j++;
      }
      i = i + 3;
      j = outputBdd.length / 4;
    }
    console.log("out");
    console.log(output);
    expt = myexport(output, format);
    return expt.exportUser();
  });
};

/*
If argv help show help
*/
if (argv.help) {
  console.log("\n\nExport function\nCommand : export [--help] [--format {name}]\n--help : show help\n--format : csv (default) or json\n\n");
}

/*
If argv format call import function
*/
if (argv.format) {
  var format = "csv";
  if (argv.format === 'json') {
    // Export to json
    format = "json";
  }
  console.log(format);
  exportFunction(format);
}

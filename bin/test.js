var argv = require('minimist')(process.argv.slice(2));
console.dir(argv);

if (argv.help) {
  console.dir("help:" + argv.help);
} else {
  console.log("command help is null")
}

if (argv.format) {
  console.log("format:" + argv.format);
} else {
  console.log("command format is null")
}



/*
Method 1: minimist (plus simple !!)
Exemple launch: node bin/test.js --help bouh
elimine les argument node & bin/test.js
output : { _: [], help: 'bouh' }

parser en json pour récuperer objet avant
transfomrer en array & validation des valeurs
*/

/*
import 2: parameters
paramters = require 'parameters'
module.export = parameters
  name:'masson'
  description: 'cluster dployment and mngt'
  oprions: [
    name: 'config'
  ]
...
*/

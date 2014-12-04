fs = require "fs"
stringify = require "csv-stringify"
csv = require "csv"
stringifier = stringify(delimiter: ";")
data = ""
# Flag 'a' append at the end
wstream = fs.createWriteStream(__dirname + "/../public/resources/users.csv",
  flags: "a"
)

# Flag 'w' remove all and write
#wstream = fs.createWriteStream(__dirname + "/../public/resources/users.csv",
#  flags: "w"
#)


module.exports = (arrayToSave) ->
  # Catch error stringifier
  stringifier.on "error", (err) ->
    consol.log err.message
    return

  # Adding data during readable
  stringifier.on "readable", ->
    data += row  while row = stringifier.read()
    return

  # Write on csv file at the end
  stringifier.on "finish", ->
    console.log "end:" + data
    wstream.write data
    return

  # Do pipe
  exportUser: () ->
    i = 0
    while i < arrayToSave.length
      stringifier.write arrayToSave[i]
      i++

    stringifier.end()
    wstream.end()

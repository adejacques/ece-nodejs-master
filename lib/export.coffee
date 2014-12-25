fs = require "fs"
stringify = require "csv-stringify"
csv = require "csv"
createSource = require "stream-json"

stringifier = stringify(delimiter: ";")
data = ""
myformat = "csv"
myjson = ""

source = createSource()
objectCounter = 0

###
#Flag 'a' append at the end
wstream = fs.createWriteStream(__dirname + "/../public/resources/export.csv",
  flags: "a"
)

#Flag 'w' remove all and write
wstream = fs.createWriteStream(__dirname + "/../public/resources/export.csv",
  flags: "w"
)
###

module.exports = (arrayToSave, format) ->
  myformat = format if format
  # If format is json, export to json file
  if myformat is "json"
    wstream = fs.createWriteStream(__dirname + "/../public/resources/export.json",
      flags: "w"
    )

    source.on "startObject", ->
     ++objectCounter

    source.on "end", ->
        console.log "Found "+ objectCounter+ " objects."

  else
    # else format export to csv file (default format)
    wstream = fs.createWriteStream(__dirname + "/../public/resources/export.csv",
      flags: "w"
    )

    # Catch error stringifier
    stringifier.on "error", (err) ->
      console.log err.message
      return

    # Adding data during readable
    stringifier.on "readable", ->
      data += row  while row = stringifier.read()
      return

    #stringifier.on "writable", (err) ->
    #  data += row  while row = stringifier.read()
    #  return

    # Write on csv file at the end
    stringifier.on "finish", ->
      #console.log "end:" + data
      wstream.write data
      return


  # Do pipe, export user function
  exportUser: () ->
    if myformat is "json"
      myJSON = JSON.stringify({users: arrayToSave})
      wstream.write myJSON
    else
      i = 0
      while i < arrayToSave.length
        stringifier.write arrayToSave[i]
        i++

      stringifier.end()

    wstream.end()

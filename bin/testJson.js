var obj =
  {"total_rows":129,"offset":0,"rows":[
    { "id":"change1_0.6995461115147918"
    , "key":"change1_0.6995461115147918"
    , "value":{"rev":"1-e240bae28c7bb3667f02760f6398d508"}
    , "doc":{
      "_id":  "change1_0.6995461115147918"
      , "_rev": "1-e240bae28c7bb3667f02760f6398d508","hello":1}
    },
  { "id":"change2_0.6995461115147918"
    , "key":"change2_0.6995461115147918"
    , "value":{"rev":"1-13677d36b98c0c075145bb8975105153"}
    , "doc":{
      "_id":"change2_0.6995461115147918"
      , "_rev":"1-13677d36b98c0c075145bb8975105153"
      , "hello":2
    }
  },
]};

var arr = []

var streamify = require('json-array-stream')

obj.stream().pipe(streamify()).pipe(res)

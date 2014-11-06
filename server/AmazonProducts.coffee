aws = require 'aws-lib'
accessKeyId = process.env.AWS_ACCESS_KEY_ID
secretKeyId = process.env.AWS_SECRET_KEY_ID

module.exports = class AWS
  constructor: ->
    @prodAdv = aws.createProdAdvClient(accessKeyId, secretKeyId, "dummyTag")

  itemLookup: (id, callback) =>
    @prodAdv.call "ItemLookup",
      {
        ItemId: id
        IdType: "ASIN"
      }
    , (err, result) ->
       callback(JSON.stringify(result))

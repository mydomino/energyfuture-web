aws = require 'aws-lib'
_ = require 'lodash'
accessKeyId = process.env.AWS_ACCESS_KEY_ID
secretKeyId = process.env.AWS_SECRET_KEY_ID

module.exports = class AWS
  constructor: ->
    @prodAdv = aws.createProdAdvClient(accessKeyId, secretKeyId, "dummyTag")

  extractBookInfo: (data) =>
    item = data.Items.Item
    imageUrl: item.LargeImage.URL
    authors: item.ItemAttributes.Author.join(", ")

  itemLookup: (ids, callback) =>
    @prodAdv.call "ItemLookup",
      ItemId: ids[0]
      IdType: "ASIN"
      ResponseGroup: "Reviews,Images,Small"
    , (err, result) =>
       callback(@extractBookInfo(result))

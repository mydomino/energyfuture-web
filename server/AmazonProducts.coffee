aws = require 'aws-lib'
_ = require 'lodash'
accessKeyId = process.env.AWS_ACCESS_KEY_ID
secretKeyId = process.env.AWS_SECRET_KEY_ID

module.exports = class AWS
  constructor: ->
    @prodAdv = aws.createProdAdvClient(accessKeyId, secretKeyId, "dummyTag")

  extractBookInfo: (data) =>
    items = data.Items.Item
    _.map items, (item) ->
      author = item.ItemAttributes.Author
      author = author.join(", ") if _.isArray(author)

      imageUrl: item.LargeImage.URL
      authors: author

  itemLookup: (ids, callback) =>
    @prodAdv.call "ItemLookup",
      ItemId: ids.join(',')
      IdType: "ASIN"
      ResponseGroup: "Reviews,Images,Small"
    , (err, result) =>
      callback(@extractBookInfo(result))

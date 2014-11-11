_ = require 'lodash'
aws = require 'aws-lib'
request = require 'request'
cheerio = require 'cheerio'
Q = require 'q'

accessKeyId = process.env.AWS_ACCESS_KEY_ID
secretKeyId = process.env.AWS_SECRET_KEY_ID

module.exports = class AWS
  constructor: ->
    @prodAdv = aws.createProdAdvClient(accessKeyId, secretKeyId, "dummyTag")

  extractBookInfo: (data) =>
    items = data.Items.Item
    _.map items, (item) ->
      reviewsUrl = item.CustomerReviews.IFrameURL
      author = item.ItemAttributes.Author
      author = author.join(", ") if _.isArray(author)
      itemLink = item.DetailPageURL
      deferred = Q.defer()

      request reviewsUrl, (error, response, body) =>
        if not error and response.statusCode is 200
          $ = cheerio.load(body)
          data =
            imageUrl: item.LargeImage.URL
            authors: author
            avgStarRatingImage: $('.crAvgStars img').attr('src')
            reviewCount: $('.crAvgStars a').last().text().match(/\d+/)[0]
            itemLink: itemLink
          deferred.resolve(data)

      deferred.promise

  itemLookup: (ids, callback) =>
    @prodAdv.call "ItemLookup",
      ItemId: ids.join(',')
      IdType: "ASIN"
      ResponseGroup: "Reviews,Images,Small"
    , (err, result) =>
      Q.all(@extractBookInfo(result)).then (data) =>
        callback(data)

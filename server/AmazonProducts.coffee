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

  extractProductInfo: (data) =>
    items = data.Items.Item
    _.chain(items)
      .map (item) ->
        unless item.LargeImage
          console.log "Missing image for item: #{item.ItemAttributes.Title}"
          return
        if _.contains(item.ItemAttributes.ProductGroup.toLowerCase(), 'book')
          creators = item.ItemAttributes.Author
          creators = creators.join(", ") if _.isArray(creators)
        else
          creators = item.ItemAttributes.Manufacturer

        reviewsUrl = item.CustomerReviews.IFrameURL
        imageUrl = item.LargeImage.URL
        itemLink = item.DetailPageURL
        deferred = Q.defer()

        request reviewsUrl, (error, response, body) =>
          if not error and response.statusCode is 200
            $ = cheerio.load(body)
            data =
              imageUrl: imageUrl
              creators: creators
              avgStarRatingImage: $('.crAvgStars img').attr('src')
              reviewCount: $('.crAvgStars a').last().text().match(/\d+/)[0]
              itemLink: itemLink
            deferred.resolve(data)

        deferred.promise
      .compact()
      .value()

  itemLookup: (ids, callback) =>
    @prodAdv.call "ItemLookup",
      ItemId: ids.join(',')
      IdType: "ASIN"
      ResponseGroup: "Reviews,Images,Small"
    , (err, result) =>
      Q.all(@extractProductInfo(result)).then (data) =>
        callback(data)

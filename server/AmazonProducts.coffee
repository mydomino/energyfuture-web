_ = require 'lodash'
aws = require 'aws-lib'
request = require 'request'
cheerio = require 'cheerio'
Q = require 'q'
url = require 'url'

accessKeyId = process.env.AWS_ACCESS_KEY_ID
secretKeyId = process.env.AWS_SECRET_KEY_ID

module.exports = class AWS
  constructor: ->
    @prodAdv = aws.createProdAdvClient(accessKeyId, secretKeyId, "dummyTag")

  extractProductInfo: (data) =>
    items = data.Items.Item
    items = [items] unless _.isArray(items)
    _.chain(items)
      .map (item) ->
        unless item.LargeImage
          console.error "Missing image for item: #{item.ASIN}"
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
            reviewRegex = /[1-9](?:\d{0,2})(?:,\d{3})*(?:\.\d*[1-9])?|0?\.\d*[1-9]|0/
            itemURL = url.parse(itemLink)
            itemURL.hash = "customerReviews"
            reviewsLink = url.format(itemURL)
            data =
              id: item.ASIN
              imageUrl: imageUrl
              creators: creators
              avgStarRatingImage: $('.crAvgStars img').attr('src')
              reviewCount: $('.crAvgStars a').last().text().match(reviewRegex)
              itemLink: itemLink
              reviewsLink: reviewsLink
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

_ = require 'lodash'
aws = require 'aws-lib'
request = require 'request'
cheerio = require 'cheerio'
Q = require 'q'
url = require 'url'

accessKeyId = process.env.AWS_ACCESS_KEY_ID
secretKeyId = process.env.AWS_SECRET_KEY_ID

module.exports = class AmazonProducts
  constructor: ->
    @prodAdv = aws.createProdAdvClient(accessKeyId, secretKeyId, "dummyTag")

  requestProductMeta: (reviewsUrl) =>
    deferred = Q.defer()

    request reviewsUrl, (error, response, body) =>
      if error or response.statusCode is 403
        deferred.reject(new Error(error))
      else
        if response.statusCode is 200
          $ = cheerio.load(body)
          reviewRegex = /[1-9](?:\d{0,2})(?:,\d{3})*(?:\.\d*[1-9])?|0?\.\d*[1-9]|0/
          data =
            avgStarRatingImage: $('.crAvgStars img').attr('src')
            reviewCount: $('.crAvgStars a').last().text().match(reviewRegex)
          deferred.resolve(data)

    deferred.promise

  extractProductInfo: (data) =>
    items = data.Items.Item
    items = [items] unless _.isArray(items) # api does not return an array if it's just one item

    _.map items, (item) =>
      {LargeImage, ItemAttributes, DetailPageURL, CustomerReviews} = item

      if not (LargeImage and ItemAttributes and DetailPageURL and CustomerReviews)
        console.error("Missing Amazon item information: #{item.ASIN}")
        return

      if _.contains(ItemAttributes.ProductGroup.toLowerCase(), 'book')
        creators = ItemAttributes.Author
        creators = creators.join(", ") if _.isArray(creators)
      else
        creators = ItemAttributes.Manufacturer

      itemURL = url.parse(DetailPageURL)
      itemURL.hash = "customerReviews"
      reviewsLink = url.format(itemURL)

      baseProductInfo =
        id: item.ASIN
        imageUrl: LargeImage.URL
        creators: creators
        itemLink: DetailPageURL
        reviewsLink: reviewsLink

      @requestProductMeta(CustomerReviews.IFrameURL)
      .then((metaData) =>
        _.merge(metaData, baseProductInfo))
      .fail((e) =>
        console.error("Error in fetching product metadata #{e}")
        false)

  itemLookup: (ids, successCallback, errorCallback) =>
    @prodAdv.call "ItemLookup",
      ItemId: ids.join(',')
      IdType: "ASIN"
      ResponseGroup: "Reviews,Images,Small"
    , (err, result) =>
      return errorCallback(err) if err

      Q.all(@extractProductInfo(result)).then (res) =>
        data = _.compact(res)
        return errorCallback() if _.isEmpty(data)
        successCallback(data)

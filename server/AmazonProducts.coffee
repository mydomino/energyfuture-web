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

    data = _.chain(items)
      .map (item) =>
        image = item.LargeImage
        attrs = item.ItemAttribute

        unless image?
          console.error "Missing image for item: #{item.ASIN}"
          return

        unless attrs?
          console.error "Missing attributes for item: #{item.ASIN}"
          return

        if _.contains(attrs.ProductGroup.toLowerCase(), 'book')
          creators = attrs.Author
          creators = creators.join(", ") if _.isArray(creators)
        else
          creators = attrs.Manufacturer

        imageUrl = image.URL
        itemLink = item.DetailPageURL
        itemURL = url.parse(item.DetailPageURL)
        itemURL.hash = "customerReviews"
        reviewsLink = url.format(itemURL)

        baseProductInfo =
          id: item.ASIN
          imageUrl: imageUrl
          creators: creators
          itemLink: itemLink
          reviewsLink: reviewsLink

        @requestProductMeta(item.CustomerReviews.IFrameURL)
        .then((metaData) => _.merge(metaData, baseProductInfo))
        .fail((e) => errors.push(e))

      .compact()
      .value()

  itemLookup: (ids, successCallback, errorCallback) =>
    @prodAdv.call "ItemLookup",
      ItemId: ids.join(',')
      IdType: "ASIN"
      ResponseGroup: "Reviews,Images,Small"
    , (err, result) =>
      unless err
        Q.all(@extractProductInfo(result)).then (data) =>
          successCallback(data)
      else
        errorCallback()

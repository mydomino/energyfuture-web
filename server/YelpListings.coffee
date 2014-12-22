_ = require 'lodash'
yelp = require 'yelp'

consumerKey = process.env.YELP_CONSUMER_KEY
consumerSecret = process.env.YELP_CONSUMER_SECRET
token = process.env.YELP_TOKEN
tokenSecret = process.env.YELP_TOKEN_SECRET

module.exports = class YelpListings
  constructor: ->
    @yelp = yelp.createClient(consumer_key: consumerKey, consumer_secret: consumerSecret, token: token, token_secret: tokenSecret)

  search: (q, successCallback, errorCallback) ->
    @yelp.search(q, (error, data) ->
      if error
        console.error(error)
        return errorCallback(error)
      else
        return successCallback(data))

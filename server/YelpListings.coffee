_ = require 'lodash'
yelp = require 'yelp'
cheerio = require 'cheerio'
Q = require 'q'

consumerKey = process.env.YELP_CONSUMER_KEY
consumerSecret = process.env.YELP_CONSUMER_SECRET
token = process.env.YELP_TOKEN
tokenSecret = process.env.YELP_TOKEN_SECRET

module.exports = class YelpListing
  constructor: ->
    @yelp = yelp.createClient(consumer_key: consumerKey, consumer_secret: consumerSecret, token: token, token_secret: tokenSecret)

  search: (term, location, callback) ->
    @yelp.search({ term: term, location: location }, (error, data) ->
      console.error(error)
      return callback(error || data))

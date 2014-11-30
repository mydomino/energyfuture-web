request = require 'superagent'
_ = require 'lodash'
yql = require './yql'

QUERY = _.template 'SELECT * FROM local.search WHERE latitude="<%= lat %>" and longitude="<%= lng %>" and query="<%= query %>"'

module.exports =
  search: (lat, lng, query, callback) ->
    sql = QUERY
      lat: lat
      lng: lng
      query: query

    request.get yql.getUrlFromQuery(sql), (r) ->
      callback r.body.query.results.Result

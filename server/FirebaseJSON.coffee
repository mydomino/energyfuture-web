_ = require 'lodash'
request = require 'request'

url = (node) ->
  "#{process.env.FIREBASE_URL}/#{node}.json"

fetch = (node, callback) ->
  options =
    uri: url(node)
    json: true

  request options, (error, response, body) ->
    if error
      callback 500, [{ error: JSON.stringify(error), response: JSON.stringify(response) }]
    else if response.statusCode == 200
      callback 200, _.values body
    else
      callback response.statusCode, { error: 'unknown error' }

module.exports = fetch

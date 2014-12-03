_ = require 'lodash'
request = require 'request'

URL = "#{process.env.FIREBASE_URL}/answers.json"

fetchJSON = (callback) ->
  options =
    uri: URL
    json: true

  request options, (error, response, body) ->
    if error
      callback 500, [{ error: JSON.stringify(error), response: JSON.stringify(response) }]
    else if response.statusCode == 200
      callback 200, _.values body
    else
      callback response.statusCode, { error: 'unknown error' }

module.exports = fetchJSON

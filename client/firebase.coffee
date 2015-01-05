rootUrl = "https://energyfuture-dev.firebaseio.com"

Firebase = require 'firebase'

urlFor = (path) ->
  path = "/#{path}" if path and path[0] != '/'
  "#{rootUrl}#{path || ''}"

module.exports =
  urlFor: urlFor
  inst: (path) ->
    new Firebase(urlFor(path))

BASE_URL = 'https://query.yahooapis.com/v1/public/yql'

# Alias for shorter code
encode = encodeURIComponent

toQueryString = (obj) ->
  parts = []
  for each of obj
    if obj.hasOwnProperty(each)
      parts.push encode(each) + "=" + encode(obj[each])

  parts.join "&"

module.exports =
  getUrlFromQuery: (query) ->
    [BASE_URL, toQueryString(q: query, format: 'json')].join('?')

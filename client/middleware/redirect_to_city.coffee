store = require 'store'
request = require 'superagent'

getCity = (callback) ->
  request.get 'http://ipinfo.io/199.133.10.140/city', (r) ->
    if r.text
      callback(r.text.trim().toLowerCase())
    else
      callback()

module.exports = (ctx, next) ->
  if store.get('firstVisit')
    next()
  else
    getCity (city) ->
      if city == 'fort collins'
        page.redirect('/fortcollins')
      else
        next()

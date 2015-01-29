store = require 'store'

module.exports = (ctx, next) ->
  if store.get('firstVisit')
    next()
  else
    page.redirect('/')

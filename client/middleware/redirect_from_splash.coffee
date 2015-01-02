store = require 'store'

module.exports = (ctx, next) ->
  if store.get('firstVisit')
    page.redirect('/guides')
  else
    store.set('firstVisit', new Date)
    next()

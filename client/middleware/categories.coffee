Categories = require '../models/singletons/Categories'

module.exports = (ctx, next) ->
  if Categories.categories() == {}
    Categories._firebase().once 'value', (-> next())
  else
    next()

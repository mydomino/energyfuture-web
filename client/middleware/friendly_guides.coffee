_ = require 'lodash'
FriendlyGuides = require '../models/singletons/FriendlyGuides'

module.exports = (ctx, next) ->
  if FriendlyGuides.loaded
    next()
  else
    FriendlyGuides._firebase().once 'value', -> next()

_ = require 'lodash'
DominoCollection = require './DominoCollection'

module.exports = class UserCollection extends DominoCollection
  url: -> "/users"

  getUserById: (uId) ->
    return null unless @models
    _.find @models, (_,id) ->
      id == uId

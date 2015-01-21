_ = require 'lodash'
DominoCollection = require './DominoCollection'

module.exports = class UserCollection extends DominoCollection
  url: -> "/users"

  getUserById: (uId) ->
    return null unless @models
    _.find @models, (_,id) ->
      id == uId

  getUserByEmail: (email) ->
    # TODO:
    # - expose endpoint on server-side for UserCollection calls. This way,
    #   privacy information of all users are not exposed client side.
    # - instead of iterating over the whole user list, find a way manipulate data
    #   with the user object earlier on, if available
    return null unless @models
    _.find @models, (attrs, _) ->
      attrs.email == email

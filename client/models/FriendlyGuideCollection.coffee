_ = require 'lodash'
DominoCollection = require './DominoCollection'

module.exports = class FriendlyGuideCollection extends DominoCollection
  url: -> "/friendly-guides"

  idFor: (friendlyGuideId) ->
    @models[friendlyGuideId] || friendlyGuideId

  nameFor: (id) ->
    _.invert(@models)[id] || id

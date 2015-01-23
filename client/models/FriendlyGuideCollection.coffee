DominoCollection = require './DominoCollection'

module.exports = class FriendlyGuideCollection extends DominoCollection
  url: -> "/friendly-guides"

  guideIdFor: (friendlyGuideId) ->
    @models[friendlyGuideId] || friendlyGuideId

_ = require 'lodash'
Tip = require './Tip'
DominoCollection = require './DominoCollection'

module.exports = class TipCollection extends DominoCollection
  url: -> "/tips"

  add: (tip) ->
    ref = @_firebase().push()
    tip.id = ref.name()
    ref.set(tip)

  tips: ->
    _.map @models, (tip) -> new Tip(tip)

  getTipsByGuide: (guideId) ->
    _.filter @tips(), (t) ->
      t.get('guideId') == guideId

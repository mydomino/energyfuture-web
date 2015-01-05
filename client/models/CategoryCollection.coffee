_ = require 'lodash'
DominoCollection = require './DominoCollection'

module.exports = class CategoryCollection extends DominoCollection
  url: -> "/categories"

  colorFor: (name) ->
    # @loaded && @models[name]?.color
    # looks like category colour is not used anymore
    # hardcoding for the time being
    "#7BD1C0"

  categories: -> @models

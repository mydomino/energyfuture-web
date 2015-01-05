_ = require 'lodash'
DominoCollection = require './DominoCollection'

module.exports = class CategoryCollection extends DominoCollection
  url: -> "/categories"

  colorFor: (name) ->
    "#7BD1C0"

  categories: -> @models

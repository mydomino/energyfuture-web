_ = require 'lodash'
DominoCollection = require './DominoCollection'

module.exports = class CategoryCollection extends DominoCollection
  url: -> "/categories"

  colorFor: (name) ->
    @loaded && @models[name].color

  categories: -> @models

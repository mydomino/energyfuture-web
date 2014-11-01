_ = require 'lodash'
DominoCollection = require './DominoCollection'

module.exports = class CategoryCollection extends DominoCollection
  url: -> "/categories"

  categories: -> @models

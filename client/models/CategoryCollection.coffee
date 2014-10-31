_ = require 'lodash'
Category = require './Category'
DominoCollection = require './DominoCollection'

module.exports = class CategoryCollection extends DominoCollection
  url: -> "/categories"

  categories: -> @models

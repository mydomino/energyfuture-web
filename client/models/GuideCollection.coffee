_ = require 'lodash'
Guide = require './Guide'
DominoCollection = require './DominoCollection'

module.exports = class GuideCollection extends DominoCollection
  url: -> "/tasks"

  groupByCategory: ->
    _.reduce @models, ((memo, m) =>
      category = m.category || 'extras'
      if memo[category]?
        memo[category].push(new Guide(m))
      else
        c = {}
        c[category] = [new Guide(m)]
        _.merge(memo, c)
      memo
    ), {}
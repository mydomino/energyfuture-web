_ = require 'lodash'
Guide = require './Guide'
DominoCollection = require './DominoCollection'

module.exports = class GuideCollection extends DominoCollection
  url: -> "/guides"

  guidesByCategory: ->
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

  scoreByCategory: ->
    _.reduce @models, ((memo, m) =>
      category = m.category || 'extras'
      if memo[category]?
        memo[category] += Number(m.score)
      else
        c = {}
        c[category] = Number(m.score)
        _.merge(memo, c)
      memo
    ), {}

  totalScore: ->
    _.reduce @models, ((memo, m) =>
      memo += Number(m.score)
      memo
    ), 0

  guides: ->
    _.map @models, (guide) -> new Guide(guide)

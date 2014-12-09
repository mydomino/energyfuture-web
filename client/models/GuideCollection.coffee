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

  guides: (opts) ->
    allGuides = _.chain(@models)
      .map (m) ->
        new Guide(m)
    if opts.ownership
      allGuides = allGuides.filter (m) ->
        guideOwnership = m.get('ownership')
        _.isUndefined(guideOwnership) || guideOwnership == opts.ownership
    if opts.sortByImpactScore
      allGuides = allGuides.sortBy (g) ->
        g.score()
      .reverse()
    allGuides.value()

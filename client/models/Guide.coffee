_ = require 'lodash'
firebase = require '../firebase'
DominoModel = require './DominoModel'
FriendlyGuides = require './singletons/FriendlyGuides'

module.exports = class Guide extends DominoModel
  url: ->
    "/guides/#{FriendlyGuides.guideIdFor(@id)}"

  category: ->
    @attributes['category']

  sortedModules: ->
    modules = _.map @attributes['modules'], (m, idx) ->
      m.id = idx
      m

    _.sortBy(modules, 'position')

  score: ->
    parseInt(@get('score'), 10)

  exists: ->
    !!@attributes

  moduleByKey: (moduleKey) ->
    _.find @attributes['modules'], (_, k) ->
      k == moduleKey

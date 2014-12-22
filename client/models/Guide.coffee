_ = require 'lodash'
firebase = require '../firebase'
DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/guides/#{@id}"

  category: ->
    @attributes['category']

  sortedModules: ->
    _.sortBy(_.values(@attributes['modules']), 'position')

  score: ->
    parseInt(@get('score'), 10)

  exists: ->
    !!@attributes

  moduleByKey: (moduleKey) ->
    _.find @attributes['modules'], (_, k) ->
      k == moduleKey

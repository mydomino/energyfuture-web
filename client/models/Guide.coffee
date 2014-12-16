_ = require 'lodash'
firebase = require '../firebase'
DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/guides/#{@id}"

  category: ->
    @attributes['category']

  didYouKnows: ->
    _.map @attributes['whatToKnow'], (i) -> i.content

  modules: ->
    _.pluck _.sortBy(@attributes['modules'], 'position'), 'name'

  sortedModules: ->
    _.sortBy(_.values(@attributes['modules']), 'position')

  score: ->
    parseInt(@get('score'), 10)

  exists: ->
    !!@attributes

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

  score: ->
    parseInt(@get('score'), 10)

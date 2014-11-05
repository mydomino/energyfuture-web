firebase = require '../firebase'
_ = require 'lodash'
DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/guides/#{@id}"

  update: (data) ->
    @_firebase().update(data)

  category: ->
    @attributes['category']

  didYouKnows: ->
    _.map @attributes['whatToKnow'], (i) -> i.content

  modules: ->
    _.pluck _.sortBy(@attributes['modules'], 'position'), 'name'

firebase = require '../firebase'
_ = require 'lodash'
DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/guides/#{@id}"

  update: (data) ->
    @_firebase().update(data)

  didYouKnows: ->
    _.map @attributes['whatToKnow'], (i) -> i.content

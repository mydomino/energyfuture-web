_ = require 'lodash'
firebase = require '../firebase'
DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/tasks/#{@id}"

  didYouKnows: ->
    _.map @attributes['whatToKnow'], (i) -> i.content

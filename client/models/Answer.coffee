_ = require 'lodash'
DominoModel = require './DominoModel'

module.exports = class Answer extends DominoModel
  url: -> "/answers/#{@id}"

  update: (data) ->
    @_firebase().set(data)

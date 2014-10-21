DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/tasks/#{@id}"

  update: (data) ->
    @_firebase().update(data)

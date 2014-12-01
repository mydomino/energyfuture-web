DominoCollection = require './DominoCollection'

module.exports = class AnswerCollection extends DominoCollection
  url: -> "/answers"

  add: (answer) ->
    ref = @_firebase().push()
    answer.id = ref.name()
    ref.set(answer)

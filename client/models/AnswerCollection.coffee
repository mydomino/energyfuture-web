_ = require 'lodash'
DominoCollection = require './DominoCollection'
Answer = require './Answer'

module.exports = class AnswerCollection extends DominoCollection
  url: -> "/answers"

  answerFor: (user_id, questionnaire_id) ->
    _.find @models, (obj, key) ->
      obj.user_id == user_id && obj.questionnaire_id == questionnaire_id

  add: (answer) ->
    existingAnswer = @answerFor(answer.user_id, answer.questionnaire_id)
    if existingAnswer
      new Answer(id: existingAnswer.id).
        update(_.merge(existingAnswer, answer))
    else
      ref = @_firebase().push()
      answer.id = ref.name()
      ref.set(answer)

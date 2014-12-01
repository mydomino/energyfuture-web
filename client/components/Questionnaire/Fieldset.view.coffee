{h2, div, label, input, textarea} = React.DOM
_ = require 'lodash'

RadioButton = require './RadioButton.view.coffee'
PaginateActions = require './PaginateActions.view.coffee'

module.exports = React.createClass
  displayName: 'Fieldset'

  sortedInputs: (inputs) ->
    _.sortBy inputs, 'position'

  render: ->
    return unless @props.moduleData

    inputTypes = @props.moduleData["input-types"]
    div {className: 'questionnaire-fieldset'},
      _.map @sortedInputs(inputTypes), (input, idx) =>
        div {className: 'fieldset-item', key: "fieldset-item-#{idx}"},
          if input.type == 'radio'
            new RadioButton(radio: input, answers: @props.answers)
      new PaginateActions(nextAction: @props.nextAction, prevAction: @props.prevAction, page: @props.page, totalPageCount: @props.totalPageCount)

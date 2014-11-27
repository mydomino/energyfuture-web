{h2, div, label, input, textarea} = React.DOM
_ = require 'lodash'

RadioButton = require './RadioButton.view.coffee'
FormActions = require './FormActions.view.coffee'

module.exports = React.createClass
  displayName: 'Fieldset'

  sortedInputs: (inputs) ->
    _.sortBy inputs, 'position'

  render: ->
    return unless @props.moduleData
    inputTypes = @props.moduleData["input-types"]
    div {className: 'questionnaire-fieldset'},
      _.map @sortedInputs(inputTypes), (input) ->
        div {className: 'fieldset-item'},
          if input.type == 'radio'
            new RadioButton(radio: input)
      new FormActions(nextAction: @props.nextAction)

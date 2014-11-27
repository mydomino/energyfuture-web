{div, h2, input, label, span} = React.DOM
_ = require 'lodash'

module.exports = React.createClass
  displayName: 'RadioButton'

  getDefaultProps: ->
    radio: {}

  render: ->
    radio = @props.radio
    return false if _.isEmpty radio
    div {className: 'questionnaire-radio'},
      h2 {className: 'questionnaire-radio-header'}, radio.text
      div {},
        _.map radio.options, (option, index) ->
          optionId = "option-#{index}"
          div {className: 'questionnaire-radio-input', key: optionId},
            input {id: optionId, type: 'radio', name: radio.name}
            label {htmlFor: optionId}, option.label

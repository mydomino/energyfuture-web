{div, h2, input, label, p} = React.DOM
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
        _.map radio.options, (option, index) =>
          optionId = "#{radio.name}-option-#{index}"
          required = if (radio.required && index == 0) then true else false
          checked = @props.answers[radio.name] == option.value
          div {className: 'questionnaire-radio-input', key: optionId},
            input {id: optionId, type: 'radio', name: radio.name, value: option.value, required: required, defaultChecked: checked, onChange: @props.changeAction}
            label {htmlFor: optionId}, option.label
            p {className: 'input-description'}, option.description if option.description

{div, input} = React.DOM

module.exports = React.createClass
  displayName: 'Action'

  render: ->
    div {className: 'questionnaire-action'},
      input {className: 'action', type: 'submit', onClick: @props.moreAction, value: @props.actionName}

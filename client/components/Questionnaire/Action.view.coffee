React = require 'react'
{div, input} = React.DOM

Action = React.createClass
  displayName: 'Action'

  render: ->
    div {className: 'questionnaire-action'},
      input {className: 'action', type: 'submit', onClick: @props.moreAction, value: @props.actionName}

module.exports = React.createFactory Action

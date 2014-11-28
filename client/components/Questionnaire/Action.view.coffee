{div} = React.DOM

module.exports = React.createClass
  displayName: 'Action'

  render: ->
    div {className: 'questionnaire-action'},
      div {className: "action", onClick: @props.moreAction}, @props.actionName

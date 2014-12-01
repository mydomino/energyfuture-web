{div, input} = React.DOM

module.exports = React.createClass
  displayName: 'Action'

  componentDidMount: ->
    #this is done to trigger html validations
    $(".questionnaire-form").on 'submit', (event) ->
      event.preventDefault()

  moreAction: ->
    if $('.questionnaire-form')[0].checkValidity()
      @props.moreAction()

  render: ->
    div {className: 'questionnaire-action'},
      input {className: "action", type: 'submit', onClick: @moreAction, value: @props.actionName}

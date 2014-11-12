auth = require '../../auth'

{div, textarea, input, button, h2, p, a} = React.DOM

module.exports = React.createClass
  displayName: 'NewTip'
  getDefaultProps: ->
    onComplete: ->
  getInitialState: ->
    userInput: ''
    userLocation: 'San Francisco'
    validEverywhere: false
  componentDidMount: ->
    _this = @
    @setState { userInput: '' }, ->
      setTimeout ->
        _this.refs.shareTextArea.getDOMNode().focus()
      , 500
  saveTip: ->
    content = @refs.shareTextArea.getDOMNode().value.trim()
    return false unless content
    location = @refs.locationTextInput.getDOMNode().value.trim() || null
    @props.tipCollection.add
      userId: auth._userId,
      content: content,
      location: location,
      timestamp: Date.now()
      guideId: @props.guideId
    @props.onComplete()
  toggleValidEverywhere: ->
    @setState validEverywhere: !@state.validEverywhere
  render: ->
    div {className: 'new-tip-modal'},
      div {className: 'new-tip-modal-content'},
        a {className: 'close-icon', onClick: @props.onComplete}, 'X'
        h2 {className: "guide-module-header"}, "Add A Tip"
        p {className: "guide-module-subheader"}, "Share your wisdom with the world."
        div {className: 'tip-modal-left'},
          div {className: 'tip-content'},
            textarea {className: "styled", ref: "shareTextArea", defaultValue: @state.userInput, placeholder: "Your Tip.."}
        div {className: 'tip-modal-right'},
          div {className: 'tip-content-location'},
            input {type: "checkbox", onChange: @toggleValidEverywhere, checked: @state.validEverywhere}, " This tip is valid beyond #{@state.userLocation}"
            if @state.validEverywhere
              input {type: "text", className: "styled", ref: "locationTextInput", placeholder: "Relevant Location (ie: Everywhere)"}
            else
              input {type: "hidden", ref: "locationTextInput", defaultValue: @state.userLocation}
          button {className: "button", onClick: @saveTip}, "Submit"

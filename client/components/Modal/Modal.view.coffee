{div, h2, span, p, a} = React.DOM

CloseFromKeyboardMixin =

  _closeOnEsc: (e) ->
    if e.keyCode == 27
      @resetState()

  _setListener: ->
    if @state.expanded
      document.addEventListener 'keyup', @_closeOnEsc
    else
      document.removeEventListener 'keyup', @_closeOnEsc

  componentDidMount: ->
    @_setListener()

  componentDidUpdate: ->
    @_setListener()

  componentWillUnmount: ->
    document.removeEventListener 'keyup', @_closeOnEsc

module.exports = React.createClass
  displayName: 'Modal'
  mixins: [CloseFromKeyboardMixin]

  getInitialState: ->
    expanded: true

  resetState: (newState = {expanded: false}) ->
    @setState newState
    @props.onModalClose() if @props.onModalClose

  _hidePrompt: ->
    @resetState()

  render: ->
    classes = React.addons.classSet
      modal: true
      'modal-expanded': this.state.expanded

    div {className: classes},
      span {className: 'modal-close', onClick: @_hidePrompt}, 'CLOSE X'
      div {className: 'modal-content-expanded'},
        @props.children

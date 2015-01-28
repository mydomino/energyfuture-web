React = require 'react'
{div, h2, span, p, a} = React.DOM
auth = require '../../auth'
_ = require 'lodash'

AuthMixin =
  loginEmail: ->
    @setState closed: true
    page('/login')

  loginFacebook: ->
    auth.login 'facebook'

  loginTwitter: ->
    auth.login 'twitter'

  handleLogin: (data) ->
    if data.user
      console.log 'Success! logged in as ', data.user
      @setState failedLogin: false
    else if data.error.code == "USER_CANCELLED"
      console.log 'User cancelled authentication.'
    else
      console.log 'Something really went wrong'
      @setState failedLogin: true

RePromptMixin =
  timeoutTracker: null

  incrementViewingTimer: ->
    if sessionStorage.hasOwnProperty('viewingTimer')
      sessionStorage.viewingTimer = parseInt(sessionStorage.viewingTimer, 10) + 1
    else
      sessionStorage.viewingTimer = 1

    if sessionStorage.viewingTimer >= 600
      sessionStorage.viewingTimer = 0
      @triggerPrompt()

  startTracking: ->
    unless @timeoutTracker
      @timeoutTracker = setInterval @incrementViewingTimer, 1000

  stopTracking: ->
    if @timeoutTracker
      clearTimeout @timeoutTracker
      @timeoutTracker = null

  componentDidMount: ->
    window.addEventListener('focus', @startTracking, false)
    window.addEventListener('blur', @stopTracking, false)
    @startTracking()

  componentWillUnmount: ->
    window.removeEventListener('focus', @startTracking)
    window.removeEventListener('blur', @stopTracking)
    @stopTracking()

  resetPrompt: ->
    if @isMounted()
      @setState({ attention: false, expanded: @state.expanded })

  triggerPrompt: ->
    if @isMounted()
      @resetState({ attention: true, expanded: @state.expanded })

      # Remove the attention class after 2 seconds
      setTimeout(@resetPrompt, 2000)

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

AuthBar = React.createClass
  displayName: 'AuthBar'
  mixins: [AuthMixin, CloseFromKeyboardMixin]

  getInitialState: ->
    closed: true
    expanded: false
    failedLogin: false

  resetState: (newState = {}) ->
    @setState _.extend({ closed: true, failedLogin: false, expanded: false }, newState)

  _showPrompt: (expanded) ->
    mixpanelEvent = if expanded then 'View Login Modal' else 'View Login Bar'
    mixpanel.track mixpanelEvent
    @resetState closed: false, expanded: expanded

  _hidePrompt: ->
    @resetState()

  componentDidMount: ->
    auth.on 'authStateChange', @handleLogin
    auth.on 'show-auth-prompt', @_showPrompt
    auth.on 'hide-auth-prompt', @_hidePrompt

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @handleLogin
    auth.removeListener 'show-auth-prompt', @_showPrompt
    auth.removeListener 'hide-auth-prompt', @_hidePrompt

  collapsedView: (failed) ->
    if failed
      div {className: 'auth-bar-content-collapsed'},
        p {},
          'Hmm... Something went wrong. Let\'s try that again: '
          a {onClick: @loginFacebook}, 'Facebook'
          ', '
          a {onClick: @loginTwitter}, 'Twitter'
          ', or '
          a {onClick: @loginEmail}, 'Email'
    else
      div {className: 'auth-bar-content-collapsed'},
        p {},
          'Log in with '
          a {onClick: @loginFacebook}, 'Facebook'
          ', '
          a {onClick: @loginTwitter}, 'Twitter'
          ', or '
          a {onClick: @loginEmail}, 'Email'
          ' to save your impact.'

  expandedView: (failed) ->
    if failed
      title = 'Hmm.. Something went wrong'
    else
      title = 'Save Your Impact!'

    div {className: 'auth-bar-content-expanded'},
      h2 {}, title
      a {className: 'btn', onClick: @loginFacebook}, 'Log in with Facebook'
      a {className: 'btn', onClick: @loginTwitter}, 'Log in with Twitter'
      a {className: 'btn', onClick: @loginEmail}, 'Log in with Email'

  render: ->
    return null if @props.loggedIn or @state.closed

    classes = React.addons.classSet
      'auth-bar': true
      'get-attention': this.state.attention
      'auth-bar-expanded': this.state.expanded
      'auth-bar-collapsed': !this.state.expanded

    div {className: classes},
      span {className: 'auth-bar-close', onClick: @_hidePrompt}, 'CLOSE X'
      @expandedView(@state.failedLogin)
      @collapsedView(@state.failedLogin)

module.exports = React.createFactory AuthBar

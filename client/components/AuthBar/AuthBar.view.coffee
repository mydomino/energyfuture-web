{div, h2, span, p, a} = React.DOM
auth = require '../../auth'
merge = require 'react/lib/merge'

AuthMixin =
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

userHasBeenOnlineFor10Minutes = ->
  Math.abs(new Date() - new Date(sessionStorage.sessionStartedAt)) > 60000 # 10 minutes

RePromptMixin =
  componentDidMount: ->
    if !sessionStorage.hasOwnProperty('sessionStartedAt')
      sessionStorage.sessionStartedAt = new Date()

  resetAttention: ->
    if @isMounted()
      @setState({ attention: false, expanded: @state.expanded })

  componentDidUpdate: ->
    if userHasBeenOnlineFor10Minutes()
      sessionStorage.sessionStartedAt = new Date()
      @resetState({ attention: true, expanded: @state.expanded })

      # Remove the attention class after 2 seconds
      setTimeout(@resetAttention, 2000)

module.exports = React.createClass
  displayName: 'AuthBar'
  mixins: [AuthMixin, RePromptMixin]

  getInitialState: ->
    closed: false
    expanded: false
    failedLogin: false

  resetState: (newState = {}) ->
    @setState merge({ closed: false, failedLogin: false, expanded: false }, newState)

  _showPrompt: (expanded) ->
    @resetState closed: false, expanded: expanded

  _hidePrompt: ->
    @resetState closed: true

  componentDidMount: ->
    auth.on 'authStateChange', @handleLogin
    auth.on 'show-auth-prompt', @_showPrompt
    auth.on 'hide-auth-prompt', @_hidePrompt

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @handleLogin
    auth.removeListener 'show-auth-prompt', @_showPrompt
    auth.removeListener 'hide-auth-prompt', @_hidePrompt

  thinView: (failed) ->
    if failed
      p {className: 'auth-bar-content'},
        span {}, "Hmm... Something went wrong. Let's try that again: "
        a {onClick: @loginFacebook}, 'Facebook'
        span {}, ' or '
        a {onClick: @loginTwitter}, 'Twitter'
    else
      p {className: 'auth-bar-content'},
        span {}, 'Login with '
        a {onClick: @loginFacebook}, 'Facebook'
        span {}, ' or '
        a {onClick: @loginTwitter}, 'Twitter'
        span {}, ' to save your impact and sync with mobile.'

  expandedView: (failed) ->
    if failed
      title = 'Hmm.. Something went wrong'
      subtitle = "Let's try that again"
    else
      title = 'Save Your Impact!'
      subtitle = 'and sync with our mobile app'

    div {className: 'auth-bar-content-expanded'},
      h2 {}, title
      p {}, subtitle
      a {className: 'btn', onClick: @loginFacebook}, 'Log in with Facebook'
      a {className: 'btn', onClick: @loginTwitter}, 'Log in with Twitter'

  render: ->
    return null if @props.loggedIn or @state.closed

    classes = React.addons.classSet
      'auth-bar': true
      'get-attention': this.state.attention
      'auth-bar-expanded': this.state.expanded

    div {className: classes},
      span {className: 'auth-bar-close', onClick: @_hidePrompt}, 'x'
      @expandedView(@state.failedLogin)
      @thinView(@state.failedLogin)

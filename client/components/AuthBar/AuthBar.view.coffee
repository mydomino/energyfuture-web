{div, h2, span, p, a} = React.DOM
auth = require '../../auth'

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

module.exports = React.createClass
  displayName: 'AuthBar'
  mixins: [AuthMixin]

  getInitialState: ->
    closed: false
    failedLogin: false

  handleClose: ->
    @setState closed: true

  resetState: ->
    @setState closed: false, failedLogin: false

  componentDidMount: ->
    auth.on 'authStateChange', @handleLogin
    auth.on 'show-auth-prompt', @resetState

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @handleLogin
    auth.removeListener 'show-auth-prompt', @resetState

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

    div {className: 'auth-bar'},
      span {className: 'auth-bar-close', onClick: @handleClose}, 'x'
      @expandedView(@state.failedLogin)
      @thinView(@state.failedLogin)

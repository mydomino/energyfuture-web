{div, span, p, a} = React.DOM
_ = require 'lodash'
auth = require '../../auth'

AuthMixin =
  loginFacebook: ->
    auth.login 'facebook'

  loginTwitter: ->
    auth.login 'twitter'

  handleLogin: (data) ->
    if data.error
      console.log 'something really went wrong'
      @setState failedLogin: true
    else if data.user
      console.log 'success! logged in as ', data.user
      @setState failedLogin: false
    else
      console.log 'Something went wrong'
      @setState failedLogin: true

  loginHeader: ->
    if @state.failedLogin
      h2Label = "Hmm..."
      pLabel = "Let's try that again"
    else
      h2Label = "Ready?"
      pLabel = "Log in to begin"

    return [
      h2 {}, h2Label
      p {}, pLabel
    ]

module.exports = React.createClass
  displayName: 'AuthBar'
  mixins: [AuthMixin]

  getInitialState: ->
    closed: false
    failedLogin: false

  handleClose: ->
    @setState closed: true

  componentDidMount: ->
    auth.on 'authStateChange', @handleLogin

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @handleLogin

  render: ->
    return null if @props.loggedIn or @state.closed

    div {className: 'auth-bar'},
      span {className: 'auth-bar-close', onClick: @handleClose}, 'x'
      if @state.failedLogin
        p {},
          span {}, "Hmm... Something went wrong. Let's try that again: "
          a {onClick: @loginFacebook}, 'Facebook'
          span {}, ' or '
          a {onClick: @loginTwitter}, 'Twitter'
      else
        p {},
          span {}, 'Login with '
          a {onClick: @loginFacebook}, 'Facebook'
          span {}, ' or '
          a {onClick: @loginTwitter}, 'Twitter'
          span {}, ' to save your impact and sync with mobile.'

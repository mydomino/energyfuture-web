{div, span, p, a} = React.DOM
_ = require 'lodash'
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

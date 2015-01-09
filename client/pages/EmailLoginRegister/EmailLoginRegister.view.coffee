{div, h2, form, fieldset, legend, label, input, p, a, button} = React.DOM

auth = require '../../auth'
_ = require 'lodash'

DOMValueMixin =
  getDOMValue: (name) ->
    if @refs[name]
      return @refs[name].getDOMNode().value
    else
      return null

actions = {}

actions.changePassword = React.createClass
  mixins: [DOMValueMixin]
  displayName: 'ChangePasswordView'

  getInitialState: ->
    processing: false
    errorMessage: null

  handleSubmit: (e) ->
    e.preventDefault()
    @setState processing: true
    auth.changePassword @props.email, @getDOMValue('oldPassword'), @getDOMValue('newPassword'), (err) =>
      if err
        @setState
          errorMessage: err.message
          processing: false
      else
        page '/guides'

  render: ->
    div {},
      h2 {className: 'auth-header'}, 'Change your password'
      if @state.errorMessage
        p {className: 'alert alert-error'}, @state.errorMessage
      form {},
        fieldset {},
          legend {}, 'Change password'
          div {className: 'row password'},
            label {htmlFor: 'password', tabIndex: '-1'}, 'Old password'
            input {type: 'password', className: 'password text', id: 'email', ariaRequired: true, defaultValue: '', ref: 'oldPassword'}
          div {className: 'row password'},
            label {htmlFor: 'password', tabIndex: '-1'}, 'New password'
            input {type: 'password', className: 'password text', id: 'email', ariaRequired: true, defaultValue: '', ref: 'newPassword'}
          p {},
            button {className: 'btn', onClick: @handleSubmit}, if @state.processing then 'Changing password...' else 'Change password'

actions.login = React.createClass
  displayName: 'EmailLoginView'
  mixins: [DOMValueMixin]
  getInitialState: ->
    errorMessage: null
    processing: false

  componentDidMount: ->
    if @refs.email
      @refs.email.getDOMNode().focus()

    auth.on 'authStateChange', @handleLogin

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @handleLogin

  switchToRegister: (e) ->
    e.preventDefault()
    @props.actionChangeCallback('register')

  switchToForgotPassword: (e) ->
    e.preventDefault()
    @props.actionChangeCallback('forgotPassword')

  switchToChangePassword: (params) ->
    @props.actionChangeCallback('changePassword', params)

  handleLogin: (data) ->
    errorMessage = null
    if data.user
      {email, tempPassword} = data.user.attributes
      if tempPassword
        @switchToChangePassword(email: email)
      else
        page('/guides')
    else if data.error.code == "USER_CANCELLED"
    else if data.error
      errorMessage = data.error.message
    else
      console.log 'Something really went wrong', data
      errorMessage = "Hmm.. something went wrong. Please try again."

    if @isMounted()
      @setState processing: false, errorMessage: errorMessage

  handleSubmit: (e) ->
    e.preventDefault()
    unless @state.processing
      @setState processing: true
      auth.loginWithEmail(@getDOMValue('email'), @getDOMValue('password'))

  render: ->
    div {},
      h2 {className: 'auth-header'}, 'Log in to Domino'
      p {className: 'auth-subheader'},
        "Don't have an account? "
        a {onClick: @switchToRegister, href: '#'}, "Register now"

      if @state.errorMessage
        p {className: 'alert alert-error'}, @state.errorMessage
      if @props.notificationMessage
        p {className: 'alert alert-info'}, @props.notificationMessage

      form {id: 'login', onSubmit: @handleSubmit},
        fieldset {className: 'sign-in'},
          legend {}, 'Log in to Domino'
          div {className: 'row user'},
            label {htmlFor: 'email', tabIndex: '-1'}, 'Email '
            input {type: 'text', className: 'text', id: 'email', ariaRequired: true, autoCapitalize: 'off', autoCorrect: 'off', autofocus: 'autofocus', ref: 'email'}
          div {className: 'row password'},
            label {htmlFor: 'password', tabIndex: '-1'}, 'Password '
            input {type: 'password', className: 'password text', id: 'email', ariaRequired: true, defaultValue: '', ref: 'password'}
          # p {},
          #   input {id: 'remember', type: 'checkbox', value: '1', ref: 'remember'},
          #     label {htmlFor: 'remember'}, ' Remember me'
          p {},
            a {onClick: @switchToForgotPassword, href: '#'}, "Forgot your password?"
          p {},
            button {className: 'btn', onClick: @handleSubmit}, if @state.processing then 'Logging in...' else 'Log in'

actions.forgotPassword = React.createClass
  displayName: 'EmailForgotPasswordView'
  mixins: [DOMValueMixin]

  getInitialState: ->
    errorMessage: null

  setProcessingState: ->
    @setState errorMessage: null, processing: true

  handleSubmit: (e) ->
    e.preventDefault()
    email = @getDOMValue('email')
    if _.isEmpty email
      @setState errorMessage: 'Please enter a valid email.'
      return
    @setProcessingState()
    auth.resetPassword email, (error) =>
      @setState processing: false
      if error
        @setState errorMessage: error.message
      else
        @props.actionChangeCallback('login', notificationMessage: 'Please check your email for your new password')

  render: ->
    div {},
      if @state.errorMessage
        p {className: 'alert alert-error'}, @state.errorMessage
      div {className: 'row user'},
        label {htmlFor: 'email', tabIndex: '-1'}, 'Email '
        input {type: 'text', className: 'text', id: 'email', ariaRequired: true, autoCapitalize: 'off', autoCorrect: 'off', autofocus: 'autofocus', ref: 'email', required: true}
      p {},
        button {className: 'btn', onClick: @handleSubmit}, if @state.processing then 'Resetting...' else 'Reset your password'

actions.register = React.createClass
  displayName: 'EmailRegisterView'
  mixins: [DOMValueMixin]

  getInitialState: ->
    errorMessage: null
    processing: false

  componentDidMount: ->
    if @refs.displayName
      @refs.displayName.getDOMNode().focus()

    auth.on 'authStateChange', @handleLogin

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @handleLogin

  switchToLogin: (e) ->
    e.preventDefault()
    @props.actionChangeCallback('login')

  handleLogin: (data) ->
    errorMessage = null

    if data.user
      auth._userRef.update
        displayName: @getDOMValue('displayName') || 'Unknown'
        location: @getDOMValue('location') || 'Unknown'

      page('/guides')
    else if data.error.code == "USER_CANCELLED"
    else if data.error
      errorMessage = data.error.message
    else
      errorMessage = "Hmm.. something went wrong. Please try again."

    if @isMounted()
      @setState processing: false, errorMessage: errorMessage

  handleSubmit: (e) ->
    e.preventDefault()
    unless @state.processing
      @setState processing: true
      auth.newUserFromEmail(@getDOMValue('email'), @getDOMValue('password'))

  render: ->
    div {},
      h2 {className: 'auth-header'}, 'Register for a Domino account'
      p {className: 'auth-subheader'},
        "Already have an account? "
        a {onClick: @switchToLogin, href: '#'}, "Log in now"

      if @state.errorMessage
        p {className: 'alert alert-error'}, @state.errorMessage

      form {id: 'register', onSubmit: @handleSubmit},
        fieldset {className: 'sign-in'},
          legend {}, 'Register for a Domino account'
          div {className: 'row name'},
            label {htmlFor: 'displayName', tabIndex: '-1'}, 'Name '
            input {type: 'text', className: 'text', id: 'displayName', ariaRequired: true, autoCapitalize: 'off', autoCorrect: 'off', autofocus: 'autofocus', ref: 'displayName'}
          div {className: 'row location'},
            label {htmlFor: 'location', tabIndex: '-1'}, 'City '
            input {type: 'text', className: 'text', id: 'location', ariaRequired: false, autoCapitalize: 'off', autoCorrect: 'off', ref: 'location'}
          div {className: 'row user'},
            label {htmlFor: 'email', tabIndex: '-1'}, 'Email '
            input {type: 'text', className: 'text', id: 'email', ariaRequired: true, autoCapitalize: 'off', autoCorrect: 'off', ref: 'email'}
          div {className: 'row password'},
            label {htmlFor: 'password', tabIndex: '-1'}, 'Password '
            input {type: 'password', className: 'password text', id: 'email', ariaRequired: true, defaultValue: '', ref: 'password'}
          p {},
            button {className: 'btn', onClick: @handleSubmit}, if @state.processing then 'Registering...' else 'Register'

module.exports = React.createClass
  displayName: 'EmailLoginRegister'
  getInitialState: ->
    action: 'login'
    params: {}

  switchAction: (action, opts = {}) ->
    @setState
      action: action
      params: opts

  render: ->
    div {className: 'auth'},
      new actions[@state.action] _.merge(actionChangeCallback: @switchAction, @state.params)
      p {},
        'Changed your mind? Head '
        a {href: '/guides'}, 'back to the guides'

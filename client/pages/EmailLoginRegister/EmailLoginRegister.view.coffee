{div, h2, form, fieldset, legend, label, input, p, a, button} = React.DOM

auth = require '../../auth'

DOMValueMixin =
  getDOMValue: (name) ->
    if @refs[name]
      return @refs[name].getDOMNode().value
    else
      return null

actions = {}

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

  handleLogin: (data) ->
    errorMessage = null

    if data.user
      page('/guides')
    else if data.error.code == "USER_CANCELLED"
    else if data.error
      errorMessage = data.error.message if @isMounted()
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
          #     ' · '
          #     a {className: 'alternate-context', target: '_blank'}, ' Forgot password?'
          p {},
            button {className: 'btn', onClick: @handleSubmit}, if @state.processing then 'Logging in...' else 'Log in'

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

  switchAction: (action) ->
    @setState action: action

  render: ->
    div {className: 'auth'},
      new actions[@state.action] actionChangeCallback: @switchAction
      p {},
        'Changed your mind? Head '
        a {href: '/guides'}, 'back to the guides'

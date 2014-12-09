{div, form, h1, button, p, input} = React.DOM
firebase = require '../../firebase'
auth = require '../../auth'
Mixpanel = require '../../models/Mixpanel'

module.exports = React.createClass
  displayName: 'NewsletterSignupForm'
  getInitialState: ->
    email: ''
    submitted: false
    user: auth.user
  setUser: ->
    @setState user: auth.user
  componentWillMount: ->
    auth.on 'authStateChange', @setUser
  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @setUser
  handleChange: (event) ->
    @setState email: event.target.value
  submit: ->
    Mixpanel.track 'Tips Signup', {guide_id: @props.guideId, distinct_id: @state.user?.id}
    firebaseRef = firebase.inst('/newsletter-signups')
    firebaseRef.push
      email: @state.email
      url: document?.location?.pathname || 'Unknown'
      timestamp: Math.round(new Date().getTime() / 1000)

    @state.user.newsletterSignup(@state.email) if @state.user

    @setState email: '', submitted: true

    return false

  render: ->
    return false if !@state.submitted && @state.user && @state.user.isNewsletterRecipient()

    div {className: 'newsletter-signup'},
      h1 {className: 'newsletter-signup-title'}, 'Get tipped.'
      p {className: 'newsletter-signup-subtext'}, 'Sign up for the freshest tips, news and incentives.'
      if !@state.submitted
        form {className: 'newsletter-signup-form', onSubmit: @submit},
          input {type: 'email', placeholder: 'enter your email', className: 'newsletter-signup-input', value: @state.email, onChange: @handleChange, required: 'required'}
          button {className: 'newsletter-signup-button'}, 'Submit'
      else
        p {className: 'newsletter-signup-notice'}, "Great, you're signed up!"

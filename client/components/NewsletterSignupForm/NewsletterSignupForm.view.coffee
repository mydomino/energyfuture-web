{div, form, h1, button, p, input} = React.DOM

module.exports = React.createClass
  displayName: 'NewsletterSignupForm'
  getInitialState: ->
    email: ''
    submitted: false
  handleChange: (event) ->
    @setState email: event.target.value
  submit: ->
    @setState email: '', submitted: true
    return false
  render: ->
    div {className: 'newsletter-signup'},
      h1 {className: 'newsletter-signup-title'}, 'Get tipped.'
      p {className: 'newsletter-signup-subtext'}, 'Sign up for the freshest tips, news and incentives.'
      if !@state.submitted
        form {className: 'newsletter-signup-form', onSubmit: @submit},
          input {type: 'text', placeholder: 'enter your email', className: 'newsletter-signup-input', value: @state.email, onChange: @handleChange}
          button {className: 'newsletter-signup-button'}, 'Submit'
      else
        p {className: 'newsletter-signup-notice'}, "Thanks! You've been added."

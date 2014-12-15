{div, p, a, span, br} = React.DOM

NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'

module.exports = React.createClass
  displayName: 'Layout'
  getDefaultProps: ->
    showNewsletterSignup: false
  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId if @props.showNewsletterSignup
      new Footer

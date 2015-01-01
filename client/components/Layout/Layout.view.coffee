{div, p, a, span, br} = React.DOM

auth = require '../../auth'
NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'

module.exports = React.createClass
  displayName: 'Layout'
  getDefaultProps: ->
    showNewsletterSignup: false

  handleLinkClick: (e) ->
    if e.target && e.target.target == '_blank'
      auth.prompt()

  componentWillMount: ->
    $('body').on 'click', 'a', @handleLinkClick

  componentWillUnmount: ->
    $('body').off 'click', 'a', @handleLinkClick

  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId if @props.showNewsletterSignup
      new Footer

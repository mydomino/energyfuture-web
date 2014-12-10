{div, p, a, span, br} = React.DOM

NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
LinkCatcherMixin = require '../../mixins/LinkCatcherMixin'

module.exports = React.createClass
  displayName: 'Layout'

  mixins: [LinkCatcherMixin]

  onClickTrackingLink: ->
    console.log "Track this link Layout"

  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId
      new Footer

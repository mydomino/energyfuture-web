{div, p, a, span, br} = React.DOM

NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
LinkCatcherMixin = require '../../mixins/LinkCatcherMixin'

module.exports = React.createClass
  displayName: 'Layout'

  mixins: [LinkCatcherMixin]

  onClickTrackingLink: ->
    console.log "Track this link Layout"

  trackingLinksContainer: ->
    @refs['layout-container'].getDOMNode()

  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container", ref: "layout-container"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId
      new Footer

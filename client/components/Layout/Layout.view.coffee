{div, p, a, span, br} = React.DOM

NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
LinkParserMixin = require '../../mixins/LinkParserMixin'

module.exports = React.createClass
  displayName: 'Layout'

  mixins: [LinkParserMixin]

  onClickTrackingLink: ->
    console.log "Track this link."

  trackingLinksContainer: ->
    @refs['layout-container'].getDOMNode()

  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container", ref: "layout-container"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId
      new Footer

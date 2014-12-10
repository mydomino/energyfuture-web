{div, p, a, span, br} = React.DOM

NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
LinkParserMixin = require '../../mixins/LinkParserMixin'

module.exports = React.createClass
  displayName: 'Layout'

  mixins: [LinkParserMixin]

  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container", ref: "linkContainer"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId
      new Footer

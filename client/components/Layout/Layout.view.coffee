{div, p, a, span, br} = React.DOM

NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
BindExternalLinkMixin = require '../../mixins/BindExternalLinkMixin'
auth = require '../../auth'

module.exports = React.createClass
  displayName: 'Layout'

  mixins: [BindExternalLinkMixin]

  stripQueryString: (url) ->
    url.slice(0, url.indexOf '?')

  trackExternalLinkAction: (event) ->
    mixpanel.track 'View External Link', url: @stripQueryString(unescape(event.currentTarget.href))

  getDefaultProps: ->
    showNewsletterSignup: false

  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId if @props.showNewsletterSignup
      new Footer

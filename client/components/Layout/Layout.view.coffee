{div, p, a, span, br} = React.DOM

NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
BindExternalLinkMixin = require '../../mixins/BindExternalLinkMixin'
Mixpanel = require '../../models/Mixpanel'
auth = require '../../auth'

module.exports = React.createClass
  displayName: 'Layout'

  mixins: [BindExternalLinkMixin]

  stripQueryString: (url) ->
    url.slice(0, url.indexOf '?')

  trackExternalLinkAction: (event) ->
    Mixpanel.emit 'analytics.external.click',
      distinct_id: auth.user?.id
      url: @stripQueryString(unescape(event.currentTarget.href))

  getDefaultProps: ->
    showNewsletterSignup: false

  render: ->
    div {className: "page page-#{@props.name}"},
      div {className: "container"},
        div {className: "container-padding"},
          @props.children
        new NewsletterSignup guideId: @props.guideId if @props.showNewsletterSignup
      new Footer

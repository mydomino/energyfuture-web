{div, p, a, span, br} = React.DOM

auth = require '../../auth'
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

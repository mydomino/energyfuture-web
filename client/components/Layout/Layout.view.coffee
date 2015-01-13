{div, p, a, span, br} = React.DOM

_ = require 'lodash'
auth = require '../../auth'
NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
auth = require '../../auth'
url = require 'url'

module.exports = React.createClass
  displayName: 'Layout'

  stripQueryString: (url) ->
    if _.contains(url, '?') then url.slice(0, url.indexOf '?') else url

  getDefaultProps: ->
    showNewsletterSignup: false

  handleLinkClick: (e) ->
    # track only external links that are not affiliate links
    # track internal links
    currentLoc = url.parse(document.location.href)
    linkHref = url.parse(e.currentTarget.href)
    isAffiliateLink = _.contains(e.currentTarget.classList, 'mixpanel-affiliate-link')
    isInternalLink = _.contains(e.currentTarget.classList, 'mixpanel-internal-link')
    if e.currentTarget.target == '_blank' && (currentLoc.host != linkHref.host) && !isAffiliateLink
      auth.prompt()
      mixpanel.track 'View External Link', url: @stripQueryString(unescape(e.currentTarget.href))
    if isInternalLink
      mixpanel.track 'View Internal Link', url: @stripQueryString(unescape(e.currentTarget.href))

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

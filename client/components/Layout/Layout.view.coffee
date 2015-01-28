{div, p, a, span, br} = React.DOM

_ = require 'lodash'
auth = require '../../auth'
NewsletterSignup = require '../NewsletterSignupForm/NewsletterSignupForm.view'
Footer = require '../Footer/Footer.view'
auth = require '../../auth'
url = require 'url'
ga = require('../GoogleAnalytics')
googleAnalyticsId = '/* @echo GOOGLE_ANALYTICS_ID */'

module.exports = React.createClass
  displayName: 'Layout'
  getDefaultProps: ->
    context:
      pathname: ''
    showNewsletterSignup: false
    showFooter: true

  componentDidMount: ->
    ga('create', googleAnalyticsId, 'auto')
    ga('send', 'pageview', @props.context.pathname || window.location.pathname)

  stripQueryString: (url) ->
    if _.contains(url, '?') then url.slice(0, url.indexOf '?') else url

  handleLinkClick: (e) ->
    # track only external links that are not affiliate links
    # track internal links
    currentLoc = url.parse(document.location.href)
    linkHref = url.parse(e.currentTarget.href)
    isAffiliateLink = _.contains(e.currentTarget.classList, 'mixpanel-affiliate-link')
    isInternalLink = _.contains(e.currentTarget.classList, 'mixpanel-internal-link')
    if e.currentTarget.target == '_blank' && (currentLoc.host != linkHref.host) && !isAffiliateLink
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
      if @props.showFooter
        new Footer
      new ga.Initializer

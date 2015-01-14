{div, a, iframe} = React.DOM
_ = require 'lodash'

module.exports = React.createClass
  displayName: 'TypeFormTrigger'
  propTypes:
    href: React.PropTypes.string.isRequired

  getDefaultProps: ->
    dataMode: 2
    href: null
    clickText: 'Launch me!'
    className: ''
    mixpanelProperty: 'mixpanel-property-placeholder'

  clickAction: (event) ->
    mixpanel.track 'View Typeform', action: @props.mixpanelProperty

  componentDidMount: ->
    $(@refs.typeformLink.getDOMNode()).click @clickAction
    $('body').append('<script src="https://s3-eu-west-1.amazonaws.com/share.typeform.com/share.js"></script>')


  render: ->
    property = if _.contains(@props.clickText, 'quote') then 'request-quote' else 'call-someone'
    a {className: "#{@props.className} typeform-share link", href: @props.href, ref: 'typeformLink', 'data-mode': @props.dataMode, 'data-mixpanel-property': property, onClick: @clickAction}, @props.clickText

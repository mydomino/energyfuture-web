{div, p, img, span, h2, a, ul, li} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('yelp')
  true

module.exports = React.createClass
  displayName: 'Yelp'

  getInitialState: ->
    data: []

  getDefaultProps: ->
    guide: {}

  componentDidMount: ->
    $.get "/yelp-listings", term: @props.guide.get('yelp').searchTerms[0], location: "San Fransisco", (res) =>
      @setState data: res if @isMounted()

  render: ->
    return false unless hasValidData(@props.guide)
    yelp = @props.guide.get('yelp')

    if _.isEmpty @state.data
      new LoadingIcon
    else
      div {className: 'guide-module guide-module-yelp'},
        h2 {className: 'guide-module-header'}, yelp.heading
        p {className: "guide-module-subheader"}, "Powered by Yelp.com"

        div {className: 'guide-module-content'},
          ul {className: 'yelp-list'}
            console.log(@state.data)


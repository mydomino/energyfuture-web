{div, h2} = React.DOM

Carousel = require '../../components/Carousel/Carousel.view'

hasValidData = (guide) ->
  return false unless guide
  true

module.exports = React.createClass
  displayName: 'QuickTips'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide

    items = @props.guide.get('quickTips')

    div {className: "guide-module"},
      h2 {className: 'guide-module-header'}, "Quick tips"
      div {className: 'guide-module-content'},
        new Carousel items: items

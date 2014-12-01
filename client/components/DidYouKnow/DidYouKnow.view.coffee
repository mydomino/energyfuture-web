{div, h2} = React.DOM

Carousel = require '../../components/Carousel/Carousel.view'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.didYouKnows()
  true

module.exports = React.createClass
  displayName: 'DidYouKnow'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide

    items = @props.guide.didYouKnows()

    div {className: "guide-module"},
      h2 {className: 'guide-module-header'}, "did you know?"
      div {className: 'guide-module-content'},
        new Carousel items: items

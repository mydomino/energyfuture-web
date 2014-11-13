{div, h2} = React.DOM

Autolinker = require 'autolinker'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.didYouKnows()
  true

module.exports = React.createClass
  displayName: 'DidYouKnow'

  getDefaultProps: ->
    guide: null

  attachSlider: ->
    $(@refs.slider.getDOMNode()).slick
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      slidesToScroll: 1

  componentDidMount: ->
    @attachSlider()

  componentDidUpdate: ->
    @attachSlider()

  render: ->
    return false unless hasValidData @props.guide

    items = @props.guide.didYouKnows()

    div {className: "guide-module guide-module-didyouknow"},
      h2 {className: 'guide-module-header'}, "did you know?"
      div {className: 'guide-module-content'},
        div {className: "slider", ref: 'slider'},
          items.map (item, idx) ->
            div {key: "item#{idx}", dangerouslySetInnerHTML: {"__html": Autolinker.link(item)}}

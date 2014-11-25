{div, h2} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

module.exports = React.createClass
  displayName: 'Carousel'

  getDefaultProps: ->
    items: []

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
    return false if _.isEmpty @props.items

    div {className: 'guide-module-carousel'},
      div {className: "slider", ref: 'slider'},
        @props.items.map (item, idx) ->
          div {key: "item#{idx}", dangerouslySetInnerHTML: {"__html": Autolinker.link(item)}}

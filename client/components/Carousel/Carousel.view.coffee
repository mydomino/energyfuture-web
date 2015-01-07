React = require 'react'
{div, h2} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

Carousel = React.createClass
  displayName: 'Carousel'

  getDefaultProps: ->
    items: []
    count: 1

  attachSlider: ->
    $(@refs.slider.getDOMNode()).slick
      dots: true
      infinite: true
      speed: 300
      slidesToShow: @props.count
      slidesToScroll: @props.count
      adaptiveHeight: true

  componentDidMount: ->
    @attachSlider()

  componentDidUpdate: ->
    @attachSlider()

  render: ->
    return false if _.isEmpty @props.items

    div {className: 'guide-module-carousel'},
      div {className: "slider", ref: 'slider'},
        @props.items.map (item, idx) ->
          if typeof item == 'string'
            div {key: "item#{idx}", dangerouslySetInnerHTML: {"__html": Autolinker.link(item)}}
          else
            div {key: "item#{idx}"}, item

module.exports = React.createFactory Carousel

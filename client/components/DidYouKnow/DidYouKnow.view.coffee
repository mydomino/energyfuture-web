React = require 'react'
{div, h2} = React.DOM
_ = require 'lodash'

Carousel = require '../../components/Carousel/Carousel.view'

hasValidData = (content) ->
  not _.isEmpty(content)

DidYouKnow = React.createClass
  displayName: 'DidYouKnow'

  render: ->
    return false unless hasValidData @props.content

    div {className: "guide-module"},
      h2 {className: 'guide-module-header'}, "did you know?"
      div {className: 'guide-module-content'},
        new Carousel items: @props.content

module.exports = React.createFactory DidYouKnow

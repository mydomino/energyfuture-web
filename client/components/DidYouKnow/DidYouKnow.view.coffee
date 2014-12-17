{div, h2} = React.DOM
_ = require 'lodash'

Carousel = require '../../components/Carousel/Carousel.view'

hasValidData = (content) ->
  not _.isEmpty(content)

module.exports = React.createClass
  displayName: 'DidYouKnow'

  getDefaultProps: ->
    moduleContent: null

  render: ->
    return false unless hasValidData @props.moduleContent

    div {className: "guide-module"},
      h2 {className: 'guide-module-header'}, "did you know?"
      div {className: 'guide-module-content'},
        new Carousel items: @props.moduleContent

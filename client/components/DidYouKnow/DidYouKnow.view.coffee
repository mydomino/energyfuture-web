{div, h2, p} = React.DOM

_ = require 'lodash'

module.exports = React.createClass
  displayName: 'DidYouKnow'

  getDefaultProps: ->
    items: []

  componentDidMount: ->
    $(".did-you-know").slick
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      slidesToScroll: 1

  render: ->
    div {className: "footprint"},
      div {className: "footprint-header"},
        h2 {}, "Did You Know?"
        div {className: "slider did-you-know"},
          _.map @props.items, (i) ->
            div {}, i

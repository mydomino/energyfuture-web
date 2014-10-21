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
    div {className: "content-sub-heading"},
      h2 {}, "did you know?"
      p {},
        div {className: "slider did-you-know"},
          _.map @props.items, (i) ->
            div {}, i

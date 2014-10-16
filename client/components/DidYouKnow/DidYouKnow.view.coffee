{div, h2, p} = React.DOM

module.exports = React.createClass
  displayName: 'DidYouKnow'

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
          div {}, "Public bike sharing programmes are growing rapidly around the world."
          div {}, "Drivers- stay at least 3 feet from bikers. This is law in many states and cyclists are legally allowed to occupy a full lane."
          div {}, "Biking in traffic? Ride in a straight line. Drivers can anticipate your movements easier than if you swerve into shoulders and gutters."

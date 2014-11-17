{div, h1, p, a, img} = React.DOM

module.exports = React.createClass
  displayName: 'Splash'
  continue: ->
    page '/guides'
  render: ->
    div {className: "page page-splash"},
      h1 {className: 'splash-header'}, "domino"
      p {className: 'splash-subheader'}, "We’re working together to reduce global carbon emissions by 20% before 2020. How?"
      img {className: 'splash-logo', src: 'img/splash-logo.png'}
      div {className: 'splash-logo-line'}
      p {className: 'splash-logo-annotation'}, "One small step at a time."
      a {className: 'splash-button', onClick: @continue}, "Get Started"

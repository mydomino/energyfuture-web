{div, h1, p, a, img} = React.DOM

Guides = require '../Guides/Guides.view'

module.exports = React.createClass
  displayName: 'Splash'
  continue: ->
    page '/guides'
  render: ->
    div {},
      div {className: "page page-splash"},
        div {className: 'splash-container'},
          img {className: 'splash-logo', src: 'img/splash-logo.png'}
          h1 {className: 'splash-header'}, "domino"
          p {className: 'splash-subheader'}, "Your guides to low-carbon living (and easy savings)"
          div {className: 'splash-cta'},
            a {className: 'btn splash-button', onClick: @continue}, "Click any guide to get started"
            p {}, "7,367 people in fort collins already have"

      new Guides @props

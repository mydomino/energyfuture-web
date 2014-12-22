{div, h1, p, a, img} = React.DOM

firebase = require '../../firebase'
Guides = require '../Guides/Guides.view'

module.exports = React.createClass
  displayName: 'Splash'
  getInitialState: ->
    userCount: 'Many'

  componentWillMount: ->
    ref = firebase.inst('/users')
    ref.on 'value', (snap) =>
      @setState userCount: snap.numChildren()

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
            p {}, "#{@state.userCount} people in fort collins already have"

      new Guides @props

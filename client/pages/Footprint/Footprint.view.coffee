{div, h1, button, br, span, img, p} = React.DOM

NavBar = require '../../components/NavBar/NavBar.view'

module.exports = React.createClass
  displayName: 'Footprint'
  render: ->
    div {className: "page page-footprint"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar
          p {}, 'Footprint Goes Here'

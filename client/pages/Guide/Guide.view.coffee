{div, h1, button, br, span, img, p} = React.DOM

NavBar = require '../../components/NavBar/NavBar.view'

module.exports = React.createClass
  displayName: 'Guide'
  render: ->
    div {className: "page page-guide"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar
          p {}, "Guide #{@props.params.id} Goes Here"

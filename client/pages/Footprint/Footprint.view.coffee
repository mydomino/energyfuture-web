{div, h2, p} = React.DOM

NavBar = require '../../components/NavBar/NavBar.view'

module.exports = React.createClass
  displayName: 'Footprint'
  render: ->
    div {className: "page page-footprint"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar
          div {className: "footprint"}
            div {className: "footprint-header"},
              h2 {}, "Your small choices have a big impact."
              p {}, "Here's your footprint, progress, and completed actions."
            div {className: "footprint-content"},
              p {}, "Content goes here"

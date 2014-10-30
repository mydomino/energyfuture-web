{div, h2, p, img} = React.DOM

_ = require 'lodash'

module.exports = React.createClass
  displayName: 'Fares'

  render: ->
    div {className: "fares"},
      h2 {}, "fares"
      p {}, "Powered by SMFTA"
      img {src: "/img/fares.png"}

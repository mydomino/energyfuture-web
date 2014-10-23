{div, h2, p, span} = React.DOM

_ = require 'lodash'
Dropdown = require '../Dropdown/Dropdown.view'

module.exports = React.createClass
  displayName: 'SavingsCalculator'

  getDefaultProps: ->
    locations: [{name: "San Francisco", value: 1}, {name: "New York", value: 2}]
    vehicles: [{name: "2006 Honda Civic", value: 1}, {name: "Dodge Challenger", value: 2}]
    distancesPerWeek: [{name: "100 miles", value: 1}, {name: "200 miles", value: 2}]

  render: ->
    div {className: "savings-calculator"},
      h2 {}, "potential savings"
      p {className: "sub-heading"}, "Calculator powered by CoolClimate."
      div {className: "filter"},
        span {}, "If you live in"
        new Dropdown(data: @props.locations)
        span {}, "and drive a"
        new Dropdown(data: @props.vehicles)
        span {}, "around"
        new Dropdown(data: @props.distancesPerWeek)
        span {}, "per week"

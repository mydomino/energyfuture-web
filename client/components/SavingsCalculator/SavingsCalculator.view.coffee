{div, h2, h3, p, span} = React.DOM

_ = require 'lodash'
Dropdown = require '../Dropdown/Dropdown.view'

module.exports = React.createClass
  displayName: 'SavingsCalculator'

  getDefaultProps: ->
    locations: [{name: "San Francisco", value: 1}, {name: "New York", value: 2}]
    vehicles: [{name: "2006 Honda Civic", value: 1}, {name: "Dodge Challenger", value: 2}]
    distancesPerWeek: [{name: "100 miles", value: 1}, {name: "200 miles", value: 2}]

  render: ->
    containerWidthPercent = 0.7
    if _.isEmpty(@props.guideCostPerYear) || _.isEmpty(@props.guideCarbonImpact)
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
        h3 {}, "cost / year"
        div {className: "savings-graphs"},
          div {className: "savings-graph-item"},
            div {className: "label"}, @props.yourCostPerYear.label
            div {className: "progress", style: {width: "#{100 * containerWidthPercent}%"}},
              p {className: "progress-value"}, "$ #{@props.yourCostPerYear.value}"
          div {className: "savings-graph-item"},
            div {className: "label"}, @props.costPerYear.label
            div {className: "progress", style: {width: "#{@props.costPerYear.value / @props.yourCostPerYear.value * containerWidthPercent * 100 }%"}},
            p {className: "progress-value"}, "$ #{@props.costPerYear.value}"
        h3 {}, "carbon impact"
        div {className: "savings-graphs"},
          div {className: "savings-graph-item"},
            div {className: "label"}, @props.yourCarbonImpact.label
            div {className: "progress", style: {width: "#{100 * containerWidthPercent}%"}},
              div {className: "impact-value"},
                p {className: "amount"}, @props.yourCarbonImpact.value
                p {className: "unit"}, " tons/year"
          div {className: "savings-graph-item"},
            div {className: "label"}, @props.carbonImpact.label
            div {className: "progress", style: {width: "#{@props.carbonImpact.value / @props.yourCarbonImpact.value * containerWidthPercent * 100 }%"}},
              div {className: "impact-value"},
                p {className: "amount"}, @props.carbonImpact.value
                p {className: "unit"}, " tons/year"

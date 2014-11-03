{div, h2, h3, p, span} = React.DOM

_ = require 'lodash'
Dropdown = require '../Dropdown/Dropdown.view'

SavingsGraphItem = React.createClass
  displayName: 'SavingsGraphItem'
  getDefaultProps: ->
    width: 100
    label: ''
    value: 0

  render: ->
    return false if @props.label == ''

    div {className: "savings-graph-item"},
      div {className: "label"}, @props.label
      div {className: "progress", style: {width: "#{@props.width}%"}},
        if @props.unit
          p {className: "progress-value"},
            span {className: "amount"}, @props.value
            span {className: "unit"}, @props.unit
        else
          p {className: "progress-value"}, @props.value

SavingsGraph = React.createClass
  displayName: 'SavingsGraph'
  getDefaultProps: ->
    title: 'Savings Graph'
    current: {}
    potential: {}
    valueFormat: ((v) -> v)

  render: ->
    containerWidthPercent = 0.7

    div {className: "savings-graph"},
      h3 {}, @props.title
      new SavingsGraphItem
        label: @props.current.label
        value: @props.valueFormat(@props.current.value)
        width: containerWidthPercent * 100
        unit: @props.unit

      new SavingsGraphItem
        label: @props.potential.label
        value: @props.valueFormat(@props.potential.value)
        width: @props.potential.value / @props.current.value * containerWidthPercent * 100
        unit: @props.unit

SavingsCalculatorFilter = React.createClass
  displayName: 'SavingsCalculatorFilter'
  getDefaultProps: ->
    locations: [{name: "San Francisco", value: 1}, {name: "New York", value: 2}]
    vehicles: [{name: "2006 Honda Civic", value: 1}, {name: "Dodge Challenger", value: 2}]
    distancesPerWeek: [{name: "100 miles", value: 1}, {name: "200 miles", value: 2}]

  render: ->
    div {className: "filter"},
      div {className: "filter-content"},
        span {}, "If you live in"
        new Dropdown(data: @props.locations)
        span {}, "and drive a"
        new Dropdown(data: @props.vehicles)
        span {}, "around"
        new Dropdown(data: @props.distancesPerWeek)
          span {}, "per week"

module.exports = React.createClass
  displayName: 'SavingsCalculator'

  getDefaultProps: ->
    costPerYear: {label: "The bus", value: "400"}
    carbonImpact: {label: "The bus", value: "4"}
    yourCostPerYear: {label: "Your car", value: "1000"}
    yourCarbonImpact: {label: "Your car", value: "20"}

  render: ->
    div {className: "guide-module guide-module-savingscalculator"},
      h2 {className: "guide-module-header"}, "potential savings"
      p {className: "guide-module-subheader"}, "Calculator powered by CoolClimate."
      div {className: "guide-module-content"},
        new SavingsCalculatorFilter
        new SavingsGraph
          title: 'cost / year'
          current: @props.yourCostPerYear
          potential: @props.costPerYear
          valueFormat: (v) -> "$#{v}"
        new SavingsGraph
          title: 'carbon impact'
          current: @props.yourCarbonImpact
          potential: @props.carbonImpact
          unit: 'tons / year'

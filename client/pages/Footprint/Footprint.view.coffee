{div, h2, p, span, ul, li, hr} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
GuideCollection = require '../../models/GuideCollection'
NavBar = require '../../components/NavBar/NavBar.view'
DropdownComponent = require '../../components/Dropdown/Dropdown.view'
YourProgress = require '../../components/YourProgress/YourProgress.view'

module.exports = React.createClass
  displayName: 'Footprint'

  getInitialState: ->
    guides: []

  componentWillMount: ->
    coll = new GuideCollection
    coll.on "sync", =>
      if @isMounted()
        @setState
          categorizedGuides: coll.guidesByCategory()
          categorizedScores: coll.scoreByCategory()
          totalScore: coll.totalScore()

    @setState
      categorizedGuides: coll.guidesByCategory()
      categorizedScores: coll.scoreByCategory()
      totalScore: coll.totalScore()

  render: ->
    locationData = [{name: "San Francisco", value: 1}, {name: "New York", value: 2}]
    houseData = [{name: "apartment", value: 1}, {name: "house", value: 2}]
    ownershipData = [{name: "own", value: 1}, {name: "rent", value: 2}]
    energyData = [{name: "$190/mo", value: 1}, {name: "$300/mo", value: 2}]
    carData = [{name: "Dodge Challenger", value: 1}, {name: "Carrera", value: 2}]
    carMilesData = [{name: "50 miles", value: 1}, {name: "100 miles", value: 2}]
    cycleFreqData = [{name: "rarely", value: 1}, {name: "daily", value: 2}]
    foodFreqData = [{name: "6", value: 1}, {name: "4", value: 2}]
    div {className: "page page-footprint"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar
          div {className: "footprint"}
            div {className: "footprint-header"},
              h2 {}, "Your small choices have a big impact."
              p {className: "sub-heading"}, "Here's your footprint, progress, and completed actions."
            div {className: "footprint-content"},
              h2 {}, "did you know?"
              p {className: "did-you-know-content"}, "Between our homes, cars, and food, over 50% of all greenhouse gases are the result of individual consumer choices"

              hr {className: "h-divider"}
              h2 {}, "about you"
              p {className: "sub-heading"}, "These choices help us predict your footprint and offer customized recommendations."
              div {className: "about-you-row"},
                span {className: "about-you-label"}, "Home:"
                span {className: "about-you-description"}, "You live in"
                new DropdownComponent(data: locationData, lightBackground: true)
                span {}, "in a"
                new DropdownComponent(data: houseData, lightBackground: true)
                span {}, "you"
                new DropdownComponent(data: ownershipData, lightBackground: true)
                span {}, "spending"
                new DropdownComponent(data: energyData, lightBackground: true)
                span {}, "on energy."
              div {className: "about-you-row"},
                span {className: "about-you-label"}, "Mobility:"
                span {className: "about-you-description"}, "You drive a"
                new DropdownComponent(data: carData, lightBackground: true)
                span {}, "around"
                new DropdownComponent(data: carMilesData, lightBackground: true)
                span {}, "per week, and bicycle"
                new DropdownComponent(data: cycleFreqData, lightBackground: true)
              div {className: "about-you-row"},
                span {className: "about-you-label"}, "Food:"
                span {className: "about-you-description"}, "You eat red meat"
                new DropdownComponent(data: foodFreqData, lightBackground: true)
                span {}, "times/week and dairy"
                new DropdownComponent(data: foodFreqData, lightBackground: true)
                span {}, "times/week"

              hr {className: "h-divider"}
              new YourProgress(goalReduction: 25, categorizedGuides: @state.categorizedGuides, categorizedScores: @state.categorizedScores, totalScore: @state.totalScore)

              hr {className: "h-divider"}
              h2 {}, "your badges"
              p {className: "sub-heading"}, "Win badges for unlocking achievements and taking action."
              ul {className: "badge-list"},
                li {className: "badge go-getter"}
                li {className: "badge most-dedicated"}
                li {className: "hexagon"}

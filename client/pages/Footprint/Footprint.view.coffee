{div, h2, p, span, ul, li, hr} = React.DOM

_ = require 'lodash'
auth = require '../../auth'
Guide = require '../../models/Guide'
GuideCollection = require '../../models/GuideCollection'
UserGuides = require '../../models/UserGuides'
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
DropdownComponent = require '../../components/Dropdown/Dropdown.view'
YourProgress = require '../../components/YourProgress/YourProgress.view'
ImpactScore = require '../../components/ImpactScore/ImpactScore.view'
UserPhoto = require '../../components/UserPhoto/UserPhoto.view'

FootprintHeader = React.createClass
  displayName: 'FootprintHeader'
  render: ->
    div {className: "footprint-header"},
      new UserPhoto user: @props.user
      h2 {}, @_headline()
      p {className: "sub-heading"}, @_tagline()

  _headline: ->
    if @props.user
      "Welcome back, #{@props.user.firstName()}"
    else
      "Your small choices have a big impact."

  _tagline: ->
    if @props.user
      "You're making great progress!"
    else
      "Here's your footprint, progress, and completed actions."

module.exports = React.createClass
  displayName: 'Footprint'

  getInitialState: ->
    guides: []

  componentWillMount: ->
    @coll = new GuideCollection
    @claimedGuides = new UserGuides(@props.user, 'claimed')
    @coll.on "sync", @handleSync
    @setupState(@coll)

  componentWillReceiveProps: (props) ->
    @claimedGuides = new UserGuides(props.user, 'claimed')

  componentWillUnmount: ->
    @coll.removeListener 'sync', @handleSync

  handleSync: (coll) ->
    if @isMounted()
      @setupState(coll)

  setupState: (coll) ->
    @setState
      categorizedGuides: coll.guidesByCategory()
      categorizedScores: coll.scoreByCategory()
      totalScore: coll.totalScore()

  componentDidMount: ->
    unless @props.user
      auth.emit('show-auth-prompt')

  render: ->
    locationData = [{name: "San Francisco", value: 1}, {name: "New York", value: 2}]
    houseData = [{name: "apartment", value: 1}, {name: "house", value: 2}]
    ownershipData = [{name: "own", value: 1}, {name: "rent", value: 2}]
    energyData = [{name: "$190/mo", value: 1}, {name: "$300/mo", value: 2}]
    carData = [{name: "Dodge Challenger", value: 1}, {name: "Carrera", value: 2}]
    carMilesData = [{name: "50 miles", value: 1}, {name: "100 miles", value: 2}]
    cycleFreqData = [{name: "rarely", value: 1}, {name: "daily", value: 2}]
    foodFreqData = [{name: "6", value: 1}, {name: "4", value: 2}]

    new Layout {name: 'footprint'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: "footprint"},
        new FootprintHeader user: @props.user
        div {className: "footprint-content"},
          h2 {}, "your impact"
          new ImpactScore score: @claimedGuides.getPoints()
          h2 {}, "did you know?"
          p {className: "did-you-know-content"}, "Between our homes, cars, and food, over 50% of all greenhouse gases are the result of individual consumer choices"
          hr {className: "h-divider"}
          h2 {}, "about you"
          p {className: "sub-heading"}, "These choices help us predict your footprint and offer customized recommendations."
          div {className: "about-you-row"},
            span {className: "about-you-label"}, "Home:"
            span {className: "about-you-description"}, "You live in"
            new DropdownComponent(data: locationData)
            span {}, "in a"
            new DropdownComponent(data: houseData)
            span {}, "you"
            new DropdownComponent(data: ownershipData)
            span {}, "spending"
            new DropdownComponent(data: energyData)
            span {}, "on energy."
          div {className: "about-you-row"},
            span {className: "about-you-label"}, "Mobility:"
            span {className: "about-you-description"}, "You drive a"
            new DropdownComponent(data: carData)
            span {}, "around"
            new DropdownComponent(data: carMilesData)
            span {}, "per week, and bicycle"
            new DropdownComponent(data: cycleFreqData)
          div {className: "about-you-row"},
            span {className: "about-you-label"}, "Food:"
            span {className: "about-you-description"}, "You eat red meat"
            new DropdownComponent(data: foodFreqData)
            span {}, "times/week and dairy"
            new DropdownComponent(data: foodFreqData)
            span {}, "times/week"

          hr {className: "h-divider"}
          new YourProgress(goalReduction: 25, categorizedGuides: @state.categorizedGuides, categorizedScores: @state.categorizedScores, totalScore: @state.totalScore)

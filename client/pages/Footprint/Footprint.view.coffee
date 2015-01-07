{div, h2, h3, p, span, ul, li, hr} = React.DOM

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
ScrollTopMixin = require '../../mixins/ScrollTopMixin'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
GuidePreview = require '../../components/GuidePreview/GuidePreview.view'

posClass = (num) ->
  if (num + 1) % 4 == 0 then 'guide-preview-row-end' else ''

guideStatus = (userGuides, guide) ->
  return null unless userGuides && userGuides.hasOwnProperty(guide.id)
  userGuides[guide.id].status

FootprintHeader = React.createClass
  displayName: 'FootprintHeader'
  render: ->
    div {className: "footprint-header"},
      h2 {}, @_headline()
      p {className: "sub-heading"}, @_tagline()

  _headline: ->
    "You decide your carbon impact"

  _tagline: ->
    "Use our guides to see how you can make a difference"

selectedGuides = []

module.exports = React.createClass
  displayName: 'Footprint'
  mixins: [ScrollTopMixin]

  getInitialState: ->
    guides: []
    selectedGuides: []

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
      auth.prompt(true)

  toggleGuideSelection: (guide) ->
    selectedGuides = @state.selectedGuides
    index = selectedGuides.indexOf(guide)
    if index > -1
      selectedGuides.splice(index, 1)
    else
      selectedGuides.push(guide)

    @setState selectedGuides: selectedGuides

  selectedClass: (guide) ->
    if @state.selectedGuides.indexOf(guide) > -1 then 'selected' else ''

  render: ->
    userGuides = @props.user && @props.user.get('guides')
    guides = @coll.guides(ownership: @state.ownership, sortByImpactScore: true)

    console.log @state.selectedGuides

    new Layout {name: 'footprint'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: "footprint"},
        new FootprintHeader user: @props.user
        div {className: 'footprint-sidebar'},
          div {className: "impact-calculation"},
            if @state.selectedGuides.length == 0
              "Choose some guides to get started"
            else
              "#{@state.selectedGuides.length} guides selected"

        div {className: "footprint-content"},
          h3 {}, "Your Actions"
          p {className: "sub-heading"}, "Choose one or more actions to see their impact"
          if guides.length > 0
            div {className: "guides"},
              guides.map (guide, idx) =>
                new GuidePreview
                  key: "guide#{guide.id}"
                  guide: guide
                  customClass: [posClass(idx), "small", @selectedClass(guide.id)].join(' ')
                  status: guideStatus(userGuides, guide)
                  clickAction: @toggleGuideSelection

          else
            new LoadingIcon

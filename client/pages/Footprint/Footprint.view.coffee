{div, h2, h3, p, span, strong, a, ul, li, hr} = React.DOM

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
ImpactSpiral = require '../../components/ImpactSpiral/ImpactSpiral.view'
FloatingSidebarMixin = require '../../mixins/FloatingSidebarMixin'

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
      p {className: "sub-heading"},
        @_tagline()
        a {className: 'location-point'}, "94123 (Fort Collins)"
        "?"

  _headline: ->
    "You decide your carbon impact"

  _tagline: ->
    "Can you get to 100% carbon-free in "

ActionButton = React.createClass
  displayName: 'FootprintSidebarActionButton'

  getDefaultProps: ->
    selectedGuides: []
    percent: 0

  viewGuide: (guideId, event) ->
    event.preventDefault()
    page('/guides/' + guideId)

  render: ->
    label = if @props.percent > 100 then "Talk to a Domino Concierge" else "Read This Guide"
    color = if @props.percent >= 100 then 'purple' else 'green'
    guideId = _.last(@props.selectedGuides).id

    p {},
      a {className: "btn btn-#{color}", onClick: @viewGuide.bind(this, guideId)}, label

NumberExplanation = p({className: 'explaination'}, a({}, "What do these numbers mean?"))

selectedGuides = []

module.exports = React.createClass
  displayName: 'Footprint'
  mixins: [ScrollTopMixin, FloatingSidebarMixin]

  calculateLeftOffset: (anchor, element) ->
    element.offsetLeft

  getInitialState: ->
    guides: []
    selectedGuides: []
    ownership: 'own'

  componentWillMount: ->
    mixpanel.track 'View Impact Screen'
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

  calculatePercent: (selectedGuides, claimedGuides) ->
    func = (sum, guide) ->
      return sum if claimedGuides.includesGuide(guide)
      sum + parseInt(guide.get('score'), 10)

    _.reduce(selectedGuides, func, claimedGuides.getPoints())

  render: ->
    userGuides = @props.user && @props.user.get('guides')
    guides = @coll.guides(ownership: @state.ownership, sortByImpactScore: true)
    selectedGuides = @coll.guidesByIds(@state.selectedGuides)
    percent = @calculatePercent(selectedGuides, @claimedGuides)

    new Layout {name: 'footprint'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: "footprint"},
        new FootprintHeader user: @props.user
        if @props.user
          div {className: 'footprint-sidebar', ref: 'sidebar'},
            new ImpactSpiral percent: percent
            div {className: "impact-calculation"},
              if selectedGuides.length == 0
                div {},
                  h3 {}, "Nice Work, #{@props.user.firstName()}."
                  "You're making a real impact! "
                  strong {}, 345
                  " people in "
                  strong {}, "Fort Collins"
                  " are at "
                  strong {}, "#{percent}%"
                  " or higher. The dominos are falling!"
                  NumberExplanation
              else if selectedGuides.length == 1
                guide = selectedGuides[0]
                motivationalMessage = guide.motivationalMessage || "Doing this would be great for your impact score!"
                motivationalMessage = motivationalMessage .replace('%NAME%', @props.user.firstName())
                div {},
                  h3 {}, "Great choice #{@props.user.firstName()}."
                  p {dangerouslySetInnerHTML: {"__html": motivationalMessage}}
                  new ActionButton selectedGuides: selectedGuides, percent: percent
                  NumberExplanation
              else
                guide = _.last selectedGuides
                motivationalMessage = guide.motivationalMessage || "Doing this would be great for your impact score!"
                motivationalMessage = motivationalMessage .replace('%NAME%', @props.user.firstName())
                div {},
                  h3 {}, "Nice Combination!"
                  p {dangerouslySetInnerHTML: {"__html": motivationalMessage}}
                  new ActionButton selectedGuides: selectedGuides, percent: percent
                  NumberExplanation

        div {className: "footprint-content"},
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

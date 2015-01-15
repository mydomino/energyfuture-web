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
TypeFormTrigger = require '../../components/TypeFormTrigger/TypeFormTrigger.view'
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
      p {className: "sub-heading"}, @_tagline()

  _headline: ->
    "Select one or more guides and see how they add up"

  _tagline: ->
    "Can you get to 100% carbon-free in Fort Collins?"

ActionButton = React.createClass
  displayName: 'FootprintSidebarActionButton'

  getDefaultProps: ->
    selectedGuides: []
    percent: 0

  viewGuide: (guideId, event) ->
    event.preventDefault()
    mixpanel.track 'Actions in Impact Screen', {action: 'View Guide', guide_id: guideId}
    page('/guides/' + guideId)

  render: ->
    guide = _.last(@props.selectedGuides)
    label = if @props.percent >= 100 then "Talk to us" else "Read #{guide.get('title')} Guide"
    color = if @props.percent >= 100 then 'purple' else 'green'

    p {},
      if @props.percent > 100
        new TypeFormTrigger
          className: "btn btn-#{color}",
          href: "https://mydomino.typeform.com/to/mlJ4gK"
          clickText: label
          mixpanelProperty: "Talk to Concierge from Impact Screen"
      else
        a {className: "btn btn-#{color}", onClick: @viewGuide.bind(this, guide.id)}, label

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
    if @claimedGuides
      selectedGuides = _.map(@claimedGuides.filteredGuides(), ((guide) -> guide.id ))
    else
      selectedGuides = []

    @setState
      categorizedGuides: coll.guidesByCategory()
      categorizedScores: coll.scoreByCategory()
      totalScore: coll.totalScore()
      selectedGuides: selectedGuides

  componentDidMount: ->
    unless @props.user
      auth.prompt(true)

  toggleGuideSelection: (guide) ->
    selectedGuides = @state.selectedGuides
    index = selectedGuides.indexOf(guide)
    return false if @claimedGuides.includesGuide(guide)

    if index > -1
      selectedGuides.splice(index, 1)
    else
      mixpanel.track 'Actions in Impact Screen', {action: 'Select Guide', guide_id: guide.id}
      selectedGuides.push(guide)

    @setState selectedGuides: selectedGuides

  selectedClass: (guide) ->
    if @state.selectedGuides.indexOf(guide) > -1 then 'selected' else ''

  calculatePercent: (selectedGuides, claimedGuides) ->
    func = (sum, guide) ->
      return sum if claimedGuides.includesGuide(guide)
      sum + parseInt(guide.get('score'), 10)

    _.reduce(selectedGuides, func, claimedGuides.getPoints())

  motivationalMessage: (guide, firstName) ->
    motivationalMessage = guide.get('motivationalMessage') || ""
    motivationalMessage = motivationalMessage.replace('%NAME%', firstName)
    motivationalMessage

  render: ->
    userGuides = @props.user && @props.user.get('guides')
    guides = @coll.guides(ownership: @state.ownership, sortByImpactScore: true)
    selectedGuides = @coll.guidesByIds(@state.selectedGuides)
    percent = @calculatePercent(selectedGuides, @claimedGuides)
    firstName = @props.user?.firstName() || "Friend"

    new Layout {name: 'footprint'},
      new NavBar user: @props.user, path: @props.context.pathname

      div {className: "footprint"},
        new FootprintHeader user: @props.user
        div {className: 'footprint-sidebar', ref: 'sidebar'},
          new ImpactSpiral percent: percent
          div {className: "impact-calculation"},
            if selectedGuides.length == 0
              if percent > 0
                div {},
                  h3 {}, "Nice Work."
                  "You're making a real impact and the dominos are falling!"
              else
                div {},
                  h3 {}, "Let's get started."
                  "Select one or more guides and see how they add up."
            else if selectedGuides.length > 0 && percent >= 100
              div {},
                h3 {}, "Now we're talking!"
                p {}, "Going all-in means even greater savings, health, and freedom. Questions?"
                new ActionButton selectedGuides: selectedGuides, percent: percent
            else if selectedGuides.length == 1
              guide = selectedGuides[0]
              div {},
                h3 {}, "Great choice."
                p {dangerouslySetInnerHTML: {"__html": @motivationalMessage(guide, firstName)}}
                new ActionButton selectedGuides: selectedGuides, percent: percent
            else
              guide = _.last selectedGuides
              div {},
                h3 {}, "Nice Combination!"
                p {dangerouslySetInnerHTML: {"__html": @motivationalMessage(guide, firstName)}}
                new ActionButton selectedGuides: selectedGuides, percent: percent

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

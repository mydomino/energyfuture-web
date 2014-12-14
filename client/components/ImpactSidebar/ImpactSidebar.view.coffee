{div, span, a, hr, i} = React.DOM

auth = require '../../auth'
Categories = require '../../models/singletons/Categories'
UserGuides = require '../../models/UserGuides'
ImpactScore = require '../ImpactScore/ImpactScore.view'

positionSidebar = (element) ->
  anchor = element.parentElement
  style = { position: null, top: null, left: null }

  if window.scrollY + element.offsetHeight > anchor.offsetTop + anchor.offsetHeight - 40
    style.top = (anchor.offsetHeight - element.offsetHeight) + 'px'
  else if window.scrollY > anchor.offsetTop
    style.position = 'fixed'
    style.top = '40px'
    style.left = (anchor.offsetLeft - 100) + 'px'

  for property, value of style
    element.style[property] = value

  return

FloatingSidebar =
  onScrollEventHandler: ->
    if @refs.sidebar
      positionSidebar(@refs.sidebar.getDOMNode())

  setupSidebarPositioning: ->
    window.addEventListener('scroll', @onScrollEventHandler, false);
    window.addEventListener('resize', @onScrollEventHandler, false);

  removeSidebarPositioning: ->
    window.removeEventListener('scroll', @onScrollEventHandler, false);
    window.removeEventListener('resize', @onScrollEventHandler, false);

  componentWillUnmount: ->
    @removeSidebarPositioning()

  componentDidMount: ->
    @setupSidebarPositioning()

module.exports = React.createClass
  displayName: 'ImpactSidebar'
  mixins: [FloatingSidebar]
  componentWillMount: ->
    @initUser()

  componentWillUnmount: ->
    if @props.user
      @props.user.removeListener 'sync', @setupState
    auth.removeListener 'authStateChange', @setupState

  getDefaultProps: ->
    category: ''
    guide: null
    user: null

  getInitialState: ->
    isClaimed: false
    isSaved: false

  initUser: ->
    if @props.user
      @setupState()
      @props.user.on 'sync', @setupState
    else
      auth.on 'authStateChange', @initUser

  setupState: ->
    return unless @props.user

    @savedForLater = new UserGuides(@props.user, 'saved')
    @claimedImpact = new UserGuides(@props.user, 'claimed')

    @setState @getCurrentState()

  getCurrentState: ->
    claimed = @claimedImpact?.includesGuide(@props.guide)
    saved = @savedForLater?.includesGuide(@props.guide)

    isClaimed: !!claimed
    isSaved: !!saved

  removeGuide: ->
    if @props.user
      @props.user.removeGuide @props.guide
    else
      auth.prompt(true)

  claimGuide: ->
    if @props.user
      @claimedImpact.add(@props.guide)
    else
      auth.prompt(true)

  saveGuide: ->
    if @props.user
      @savedForLater.add(@props.guide)
    else
      auth.prompt(true)

  render: ->
    claimedClass = if @state.isClaimed then 'active' else ''
    savedClass = if @state.isSaved then 'active' else if @state.isClaimed then 'disabled' else ''
    color = Categories.colorFor(@props.category) || 'inherit'

    div {className: "impact-sidebar category-#{@props.category}", style: { color: color }, ref: 'sidebar'},
      new ImpactScore score: @props.guide.score(), color: color
      hr {}
      div {className: "action-button #{claimedClass}"},
        if @state.isClaimed
          a {onClick: @removeGuide},
            i {className: "icon pu-icon pu-icon-impact-o"}
            span {}, "Done"
        else
          a {onClick: @claimGuide},
            i {className: "icon pu-icon pu-icon-impact-o"}
            span {}, "I did this"
      hr {}
      div {className: "action-button #{savedClass}"},
        if @state.isClaimed
          span {},
            i {className: "icon pu-icon pu-icon-remindme"}
            span {}, "Save for later"
        else if @state.isSaved
          a {onClick: @removeGuide},
            i {className: "icon pu-icon pu-icon-remindme"}
            span {}, "Saved for later"
        else
          a {onClick: @saveGuide},
            i {className: "icon pu-icon pu-icon-remindme"}
            span {}, "Save for later"


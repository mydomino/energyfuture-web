{div, span, a, hr, i} = React.DOM

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

module.exports = React.createClass
  displayName: 'ImpactSidebar'
  propTypes:
    user: React.PropTypes.object.isRequired

  onScrollEventHandler: ->
    if @refs.sidebar
      positionSidebar(@refs.sidebar.getDOMNode())

  setupSidebarPositioning: ->
    window.addEventListener('scroll', @onScrollEventHandler, false);
    window.addEventListener('resize', @onScrollEventHandler, false);

  removeSidebarPositioning: ->
    window.removeEventListener('scroll', @onScrollEventHandler, false);
    window.removeEventListener('resize', @onScrollEventHandler, false);

  componentWillMount: ->
    @setupState()
    @props.user.on 'sync', @setupState

  componentWillUnmount: ->
    @removeSidebarPositioning()
    @props.user.removeListener 'sync', @setupState

  componentDidMount: ->
    @setupSidebarPositioning()

  getDefaultProps: ->
    category: ''
    points: 1000
    guide: null

  getInitialState: ->
    isClaimed: false
    isSaved: true

  setupState: ->
    @savedForLater = new UserGuides(@props.user, 'saved')
    @claimedImpact = new UserGuides(@props.user, 'claimed')

    @setState @getCurrentState()

  getCurrentState: ->
    isClaimed: @claimedImpact?.includesGuide(@props.guide)
    isSaved: @savedForLater?.includesGuide(@props.guide)

  removeGuide: ->
    @props.user.removeGuide @props.guide

  render: ->
    claimedClass = if @state.isClaimed then 'active' else ''
    savedClass = if @state.isSaved then 'active' else if @state.isClaimed then 'disabled' else ''
    color = Categories.colorFor(@props.category) || 'inherit'

    div {className: "impact-sidebar category-#{@props.category}", style: { color: color }, ref: 'sidebar'},
      new ImpactScore score: @props.points, color: color
      hr {}
      div {className: "action-button #{claimedClass}"},
        if @state.isClaimed
          a {onClick: @removeGuide},
            i {className: "icon pu-icon pu-icon-impact-o"}
            span {}, "Done"
        else
          a {onClick: @claimedImpact.add.bind(@claimedImpact, @props.guide)},
            i {className: "icon pu-icon pu-icon-impact-o"}
            span {}, "I've Done This"
      hr {}
      div {className: "action-button #{savedClass}"},
        if @state.isClaimed
          span {},
            i {className: "icon pu-icon pu-icon-remindme"}
            span {}, "Save For Later"
        else if @state.isSaved
          a {onClick: @removeGuide},
            i {className: "icon pu-icon pu-icon-remindme"}
            span {}, "Saved For Later"
        else
          a {onClick: @savedForLater.add.bind(@savedForLater, @props.guide)},
            i {className: "icon pu-icon pu-icon-remindme"}
            span {}, "Save For Later"


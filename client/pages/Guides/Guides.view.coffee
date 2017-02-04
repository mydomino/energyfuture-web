{div, h1, h2, button, br, span, img, p, header} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
GuideCollection = require '../../models/GuideCollection'
Layout = require '../../components/Layout/Layout.view'
DropdownComponent = require '../../components/Dropdown/Dropdown.view'
NavBar = require '../../components/NavBar/NavBar.view'
GuidePreview = require '../../components/GuidePreview/GuidePreview.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

# CLEANUP: Switching to flexbox, this won't needed in future
posClass = (num) ->
  return 'guide-preview-row-end' if (num + 1) % 4 == 0

positionAnnotation = (element, anchor) ->
  element.style.display = 'block'
  element.style.top = (anchor.offsetTop + anchor.offsetHeight - 20) + 'px'
  element.style.left = (anchor.offsetLeft - 5) + 'px'
  return

guideStatus = (userGuides, guide) ->
  return null unless userGuides && userGuides.hasOwnProperty(guide.id)
  userGuides[guide.id].status

OnScrollMixin =
  getDefaultProps: ->
    setScrollPosEvery: 10
    scrollAfter: 5

  getInitialState: ->
    scroll:
      x: 0
      y: 0

  componentDidMount: ->
    mixpanel.track 'View Guide Grid'
    @onScroll = =>
      @setState
        scroll:
          x: window.pageXOffset
          y: window.pageYOffset

    @onScroll()

    # to prevent setting state too much
    @onScrollThrottled = _.throttle(@onScroll, @props.setScrollPosEvery)
    window.addEventListener("scroll", @onScrollThrottled)

    window?.setTimeout (=>
      window.scrollTo(0, sessionStorage.getItem(@props.scrollPositionKey))
    ), @props.scrollAfter

  componentWillUnmount: ->
    sessionStorage.setItem(@props.scrollPositionKey, @state.scroll.y)
    window.removeEventListener("scroll", @onScrollThrottled)

module.exports = React.createClass
  displayName: 'Guides'
  mixins: [OnScrollMixin, ScrollTopMixin]

  getDefaultProps: ->
    scrollPositionKey: 'guidesLastScrollPosition'

  getInitialState: ->
    ownership: "own"

  componentWillMount: ->
    @coll = new GuideCollection
    @coll.on "sync", @rerenderComponent

  componentWillUnmount: ->
    @coll.removeListener 'sync', @rerenderComponent

  componentDidMount: ->
    @loadLocalOwnership()
    @loadUserOwnership(@props.user)
    anchor = @refs.anchor.getDOMNode()
    annotation = @refs.annotation.getDOMNode()
    positionAnnotation(annotation, anchor)
    window?.onresize = ->
      positionAnnotation(annotation, anchor)

  componentWillReceiveProps: (props) ->
    @loadUserOwnership(props.user)

  loadUserOwnership: (user) ->
    if @isMounted() && user
      @setLocalOwnership user.ownership()
      @setState ownership: user.ownership()

  rerenderComponent: ->
    @forceUpdate() if @isMounted()

  ownershipChangeAction: (ownership) ->
    @setLocalOwnership ownership
    @props.user.updateOwnership(ownership) if @props.user
    if @isMounted()
      @setState ownership: ownership

  loadLocalOwnership: ->
    if @isMounted
      @setState ownership: (sessionStorage.getItem('ownership') || 'own')

  setLocalOwnership: (ownership) ->
    sessionStorage.setItem 'ownership', ownership

  render: ->
    ownershipData = [{name: "home owners", value: "own"}, {name: "renters", value: "rent"}]
    userGuides = @props.user && @props.user.get('guides')
    guides = @coll.guides(ownership: @state.ownership, sortByImpactScore: true)
    new Layout {name: 'guides', context: @props.context},
      new NavBar user: @props.user, path: @props.context.pathname

      header {className: "guides-intro"},
        h1 {className: "guides-intro-header"},
          "Your actions to "
          span {className: "intro-annotation-anchor", ref: "anchor"}, 'low-carbon living'
        div {className: "guides-user-context"},
          p {},
            span {}, "See actions for"
            new DropdownComponent(data: ownershipData, changeAction: @ownershipChangeAction, selectedOption: @state.ownership)
      if guides.length > 0
        div {className: "guides"},
          guides.map (guide, idx) =>
            new GuidePreview
              key: "guide#{guide.id}"
              guide: guide
              status: guideStatus(userGuides, guide)
      else
        new LoadingIcon
      div {className: "guides-intro-annotation", ref: "annotation"}

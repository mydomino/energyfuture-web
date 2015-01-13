React = require 'react'
ReactAsync = require 'react-async'
{div, h1, h2, button, br, span, img, p} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
GuideCollection = require '../../models/GuideCollection'
Layout = require '../../components/Layout/Layout.view'
DropdownComponent = require '../../components/Dropdown/Dropdown.view'
NavBar = require '../../components/NavBar/NavBar.view'
GuidePreview = require '../../components/GuidePreview/GuidePreview.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

posClass = (num) ->
  return 'guide-preview-third' if (num + 1) % 3 == 0

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

Guides = React.createClass
  displayName: 'Guides'
  mixins: [OnScrollMixin, ReactAsync.Mixin]

  getDefaultProps: ->
    scrollPositionKey: 'guidesLastScrollPosition'

  getInitialStateAsync: (cb) ->
    @coll = new GuideCollection
    @coll.sync().then -> cb null, ownership: 'own'

  componentWillMount: ->
    @coll = new GuideCollection
    @coll.sync().then -> @rerenderComponent()

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
    ownershipData = [{name: "home owners", value: "own"}, {name: "home renters", value: "rent"}]
    userGuides = @props.user && @props.user.get('guides')

    guides = @coll.guides(ownership: @state.ownership, sortByImpactScore: true)
    new Layout {name: 'guides'},
      new NavBar user: @props.user, path: @props.context.pathname

      div {className: "guides-intro"},
        h1 {className: "guides-intro-header"},
          "Your guides to "
          span {className: "intro-annotation-anchor", ref: "anchor"}, "low-carbon living"
        p {className: "guides-intro-subtext"},
          "In partnership with Rocky Mountain Institute and UC Berkeley"
        div {className: "guides-user-context"},
          p {},
            span {}, "All guides for"
            new DropdownComponent(data: ownershipData, changeAction: @ownershipChangeAction, selectedOption: @state.ownership)
            span {}, " in Fort Collins"
      if guides.length > 0
        div {className: "guides"},
          guides.map (guide, idx) =>
            new GuidePreview
              key: "guide#{guide.id}"
              guide: guide
              customClass: posClass(idx)
              status: guideStatus(userGuides, guide)
      else
        new LoadingIcon
      div {className: "guides-intro-annotation", ref: "annotation"}

module.exports = React.createFactory Guides

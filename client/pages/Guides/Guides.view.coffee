{div, h1, h2, button, br, span, img, p} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
GuideCollection = require '../../models/GuideCollection'
DropdownComponent = require '../../components/Dropdown/Dropdown.view'
NavBar = require '../../components/NavBar/NavBar.view'
GuidePreview = require '../../components/GuidePreview/GuidePreview.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
auth = require '../../auth'
data = require '../../sample-data'

posClass = (num) ->
  if (num + 1) % 3 == 0
    return 'guide-preview-third'
  else if (num + 1) % 3 == 1
    return 'guide-preview-first'
  else
    return ""

positionAnnotation = (element, anchor) ->
  element.style.display = 'block'
  element.style.top = (anchor.offsetTop + anchor.offsetHeight) + 'px'
  element.style.left = (anchor.offsetLeft - 15) + 'px'
  return

module.exports = React.createClass
  displayName: 'Guides'
  getDefaultProps: ->
    guides: []

  getInitialState: ->
    guides: @props.guides
    ownership: "own"

  componentWillMount: ->
    @coll = new GuideCollection
    @coll.on "sync", =>
      @refreshGuides(@state.ownership)

    auth.on 'authStateChange', (authData) =>
      ownership = authData.user.get('ownership') || 'own'
      if @isMounted()
        @setState ownership: ownership

  componentDidMount: ->
    @refreshGuides(@state.ownership)

    anchor = @refs.anchor.getDOMNode()
    annotation = @refs.annotation.getDOMNode()
    positionAnnotation(annotation, anchor)

    window?.onresize = ->
      positionAnnotation(annotation, anchor)

  refreshGuides: (ownership) ->
    if @isMounted()
      @setState guides: @coll.guides(ownership)

  ownershipChangeAction: (ownership) ->
    @setState ownership: ownership
    @refreshGuides(ownership)

  render: ->
    locationData = [{name: "San Francisco", value: 1}, {name: "New York", value: 2}]
    ownershipData = [{name: "own", value: "own"}, {name: "rent", value: "rent"}]
    div {className: "page page-guides"},
      div {className: "container"},
        div {className: "container-padding guides"},
          new NavBar long: true

          div {className: "guides-intro"},
            h1 {className: "guides-intro-header"},
              "Your helpful guides to a "
              span {className: "intro-annotation-anchor", ref: "anchor"}, "healthy planet"
            p {className: "guides-intro-subtext"},
              "In partnership with Rocky Mountain Institute and UC Berkeley"
            div {className: "guides-user-context"},
              p {},
                span {}, "If you live in "
                new DropdownComponent(data: locationData)
                span {}, " and "
                new DropdownComponent(data: ownershipData, changeAction: @ownershipChangeAction, selectedOption: @state.ownership)
                span {}, " your home."
          if @state.guides.length > 0
            div {className: "guides"},
              @state.guides.map (guide, idx) =>
                new GuidePreview
                  key: "guide#{guide.id}"
                  guide: guide
                  customClass: posClass(idx)
          else
            new LoadingIcon
      div {className: "guides-intro-annotation", ref: "annotation"}

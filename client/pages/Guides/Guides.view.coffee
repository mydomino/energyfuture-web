{div, h1, h2, button, br, span, img, p} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
GuideCollection = require '../../models/GuideCollection'
DropdownComponent = require '../../components/Dropdown/Dropdown.view'
NavBar = require '../../components/NavBar/NavBar.view'
GuidePreview = require '../../components/GuidePreview/GuidePreview.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
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

  componentWillMount: ->
    coll = new GuideCollection
    coll.on "sync", =>
      if @isMounted()
        @setState guides: coll.guides()

    @setState
      guides: coll.guides()

  componentDidMount: ->
    anchor = @refs.anchor.getDOMNode()
    annotation = @refs.annotation.getDOMNode()
    positionAnnotation(annotation, anchor)

    window?.onresize = ->
      positionAnnotation(annotation, anchor)

  render: ->
    locationData = [{name: "San Francisco", value: 1}, {name: "New York", value: 2}]
    ownershipData = [{name: "own", value: 1}, {name: "rent", value: 2}]

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
                new DropdownComponent(data: ownershipData)
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

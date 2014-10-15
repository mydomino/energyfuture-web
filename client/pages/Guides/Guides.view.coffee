{div, h1, h2, button, br, span, img, p} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
GuideCollection = require '../../models/GuideCollection'
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
    guides = new GuideCollection
    guides.on "sync", =>
      _guides = _.map guides.models, (guide) -> new Guide(guide)
      @setState guides: _guides

  componentDidMount: ->
    anchor = @refs.anchor.getDOMNode()
    annotation = @refs.annotation.getDOMNode()
    positionAnnotation(annotation, anchor)

    window?.onresize = ->
      positionAnnotation(annotation, anchor)

  render: ->
    div {className: "page page-guides"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar long: true

          div {className: "intro"},
            h1 {className: "intro-header"},
              "Your helpful guides to a "
              span {className: "intro-annotation-anchor", ref: "anchor"}, "healthy planet"
            p {className: "intro-subtext"},
              "In partnership with Rocky Mountain Institute and UC Berkeley"
            div {className: "user-context"},
              p {}, "If you live in San Francisco and Own your home."
          if @state.guides.length > 0
            div {className: "guides"},
              @state.guides.map (guide, idx) ->
                new GuidePreview
                  key: "guide#{guide.id}"
                  guide: guide
                  customClass: posClass(idx)
          else
            new LoadingIcon
      div {className: "intro-annotation", ref: "annotation"}

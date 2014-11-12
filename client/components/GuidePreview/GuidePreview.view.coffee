{div, h2, p, span} = React.DOM
Categories = require '../../models/singletons/Categories'

module.exports = React.createClass
  displayName: 'GuidePreview'
  getDefaultProps: ->
    customClass: ''

  viewGuide: ->
    page "/guide/#{@props.guide.id}"

  render: ->
    guide = @props.guide.attributes
    summary = guide.summary_short || guide.summary
    preview_bg = guide.photos?[0]
    recommended = guide.recommended
    color = Categories.colorFor(guide.category)

    style = {}
    style.borderColor = color
    if preview_bg
      style.backgroundImage = "url(#{preview_bg})"

    div {className: "guide-preview #{@props.customClass}", onClick: @viewGuide, style: style},
      if recommended
        span {className: "guide-preview-recommended", style: { backgroundColor: color }}, "Recommended"
      div {className: "guide-preview-content"},
        h2 {className: "guide-preview-title"}, guide.title
        p {className: "guide-preview-summary"}, summary

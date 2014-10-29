{div, h2, p, span} = React.DOM

module.exports = React.createClass
  displayName: 'GuidePreview'
  getDefaultProps: ->
    customClass: ''

  viewGuide: ->
    page "/guide/#{@props.guide.id}"

  render: ->
    guide = @props.guide.attributes
    summary = guide.intro?.caption
    preview_bg = guide.photos?[0]
    recommended = guide.recommended

    style = {}
    if preview_bg
      style.backgroundImage = "url(#{preview_bg})"

    div {className: "guide-preview #{@props.customClass}", onClick: @viewGuide, style: style},
      if recommended
        span {className: "guide-preview-recommended"}, "Recommended"
      div {className: "guide-preview-content"},
        h2 {className: "guide-preview-title"}, guide.title
        p {className: "guide-preview-summary"}, summary

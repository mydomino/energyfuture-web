{div, h2, p, span} = React.DOM

module.exports = React.createClass
  displayName: 'GuidePreview'
  getDefaultProps: ->
    customClass: ''

  viewGuide: ->
    page "/guide/#{@props.guide.id}"

  render: ->
    style = {}
    if @props.guide.preview_bg
      style.backgroundImage = "url(#{@props.guide.preview_bg})"

    div {className: "guide-preview #{@props.customClass}", onClick: @viewGuide, style: style},
      if @props.guide.recommended
        span {className: "guide-preview-recommended"}, "Recommended"
      div {className: "guide-preview-content"},
        h2 {className: "guide-preview-title"}, @props.guide.name
        p {className: "guide-preview-summary"}, @props.guide.summary

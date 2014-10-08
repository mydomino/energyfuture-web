{div, p} = React.DOM

module.exports = React.createClass
  displayName: 'GuidePreview'
  viewGuide: ->
    page "/guide/#{@props.guide.id}"
  render: ->
    div {className: "guide-preview"},
      p {onClick: @viewGuide}, @props.guide.name

{div, h2, p, span} = React.DOM
Categories = require '../../models/singletons/Categories'
ImpactScore = React.createFactory(require '../ImpactScore/ImpactScore.view')

_ = require 'lodash'

module.exports = React.createClass
  displayName: 'GuidePreview'

  getDefaultProps: ->
    customClass: ''

  viewGuide: ->
    page "/guides/#{@props.guide.id}"

  statusIcon: ->
    icon = switch @props.status
      when 'claimed' then 'check'
      when 'saved' then 'remindme'

    span {className: "guide-preview-status pu-icon-#{icon}"} if icon

  render: ->
    guide = @props.guide.attributes
    return false if _.isEmpty guide
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
      @statusIcon()
      div {className: "guide-preview-content"},
        h2 {className: "guide-preview-title"}, guide.title
        p {className: "guide-preview-summary"}, summary
        div {className: "guide-preview-impact-score"},
          new ImpactScore score: @props.guide.score(), color: color
          span {className: "impact-text"}, "impact"

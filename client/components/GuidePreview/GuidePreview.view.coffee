React = require 'react'
{div, h2, p, span} = React.DOM
Categories = require '../../models/singletons/Categories'
ImpactScore = require '../../components/ImpactScore/ImpactScore.view'

_ = require 'lodash'

GuidePreview = React.createClass
  displayName: 'GuidePreview'

  getDefaultProps: ->
    customClass: ''

  statusIcon: ->
    icon = switch @props.status
      when 'claimed' then 'check'
      when 'saved' then 'star'

    if icon
      div {className: "guide-preview-status guide-preview-status-#{icon}"},
        span {className: "fa fa-#{icon}"}

  handleClick: (event) ->
    event.preventDefault()

    if @props.clickAction
      @props.clickAction(@props.guide.id)
    else
      @viewGuide()

  viewGuide: (event) ->
    event && event.preventDefault()
    mixpanel.track 'Actions in Impact Screen', {action: 'View Guide', guide_id: @props.guide.id}
    page "/guides/#{@props.guide.id}"

  render: ->
    guide = @props.guide.attributes
    return false if _.isEmpty guide
    summary = guide.summary_short || guide.summary
    preview_bg = guide.photos?[0]
    recommended = guide.recommended
    color = Categories.colorFor(guide.category)

    style = {}
    # style.borderColor = color
    if preview_bg
      style.backgroundImage = "url(#{preview_bg})"

    div {className: "guide-preview #{@props.customClass}", onClick: @handleClick, style: style},
      if recommended
        span {className: "guide-preview-recommended", style: { backgroundColor: color }}, "Recommended"
      @statusIcon()
      unless @props.status == 'claimed'
        div {className: "guide-preview-hover"},
          div {className: "guide-preview-select"},
            p {className: "guide-preview-button"}, "Select"
          div {className: "guide-preview-info", onClick: @viewGuide}, "Read Guide"
      div {className: "guide-preview-content"},
        h2 {className: "guide-preview-title"}, guide.title
        p {className: "guide-preview-summary"}, summary

module.exports = React.createFactory GuidePreview

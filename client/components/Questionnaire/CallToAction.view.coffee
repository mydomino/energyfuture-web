{div, h2, p, a} = React.DOM
Mixpanel = require '../../models/Mixpanel'
TypeFormTrigger = require '../../components/TypeFormTrigger/TypeFormTrigger.view'
auth = require '../../auth'

_ = require 'lodash'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('questionnaire')
  true

module.exports = React.createClass
  displayName: 'CallToAction'
  getDefaultProps: ->
    content: {}

  viewQuestionnaire: ->
    Mixpanel.track 'View Questionnaire',
      guide_id: @props.guideId,
      distinct_id: auth.user?.id
    page "/guides/#{@props.guide.id}/questionnaire"

  render: ->
    return false unless hasValidData(@props.guide)
    title = @props.guide.get('title')
    typeforms = @props.content.typeforms

    div {className: 'guide-module'},
      h2 {className: 'guide-module-header'}, title
      div {className: 'guide-module-content guide-module-cta'},
        h2 {className: 'cta-header'}, "Ready for a free, no-obligation quote?"
        if typeforms
          div {className: 'cta-buttons'},
            typeforms.map (typeform, idx) ->
              new TypeFormTrigger
                className: 'cta-get-started',
                href: typeform.href
                clickText: typeform.clickText
                key: "typeform-#{idx}"
        else
          a {className: 'cta-get-started', onClick: @viewQuestionnaire}, "Get started"

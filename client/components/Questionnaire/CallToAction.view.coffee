{div, h2, p, a} = React.DOM
TypeFormTrigger = require '../../components/TypeFormTrigger/TypeFormTrigger.view'
auth = require '../../auth'
_ = require 'lodash'

module.exports = React.createClass
  displayName: 'CallToAction'
  getDefaultProps: ->
    content: {}

  viewQuestionnaire: ->
    mixpanel.track 'View Questionnaire', guide_id: @props.guideId
    page "/guides/#{@props.guide.id}/questionnaire"

  render: ->
    typeforms = @props.content.typeforms
    return false if _.isEmpty(typeforms)

    div {className: 'guide-module'},
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

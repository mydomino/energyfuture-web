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
    {heading, typeforms} = @props.content
    return false if _.isEmpty(typeforms)

    div {className: 'guide-module'},
      div {className: 'guide-module-content guide-module-cta'},
        if heading
          h2 {className: 'cta-header'}, heading
        div {className: 'cta-buttons'},
          typeforms.map (typeform, idx) ->
            new TypeFormTrigger
              className: 'cta-get-started',
              href: typeform.href
              clickText: typeform.clickText
              key: "typeform-#{idx}"

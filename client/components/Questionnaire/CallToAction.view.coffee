{div, h2, p, a} = React.DOM
Mixpanel = require '../../models/Mixpanel'
auth = require '../../auth'

_ = require 'lodash'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('questionnaire')
  true

module.exports = React.createClass
  displayName: 'CallToAction'

  viewQuestionnaire: ->
    Mixpanel.track 'View Questionnaire',
      guide_id: @props.guideId,
      distinct_id: auth.user?.id
    page "/guides/#{@props.guide.id}/questionnaire"

  render: ->
    return false unless hasValidData(@props.guide)
    title = @props.guide.get('title')

    div {className: 'guide-module'},
      h2 {className: 'guide-module-header'}, title
      div {className: 'guide-module-content guide-module-cta'},
        h2 {className: 'cta-header'}, "Ready for a free, no obligation quote?"
        p {className: 'cta-subheader'}, "or just want to talk to someone to get more information?"
        a {className: 'cta-get-started', onClick: @viewQuestionnaire}, "Get started"

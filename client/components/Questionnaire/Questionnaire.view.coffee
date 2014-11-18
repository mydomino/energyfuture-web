{div, h2, p, a} = React.DOM

_ = require 'lodash'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('questionnaire')
  true

module.exports = React.createClass
  displayName: 'Questionnaire'

  render: ->
    return false unless hasValidData(@props.guide)
    console.log page
    div {className: 'guide-module guide-module-questionnaire'},
      h2 {className: 'questionnaire-header'}, "Ready for a free, no obligation quote?"
      p {className: 'questionnaire-subheader'}, "or just want to talk to someone to get more information?"
      a {className: 'questionnaire-get-started', href: "#"}, "Get started"

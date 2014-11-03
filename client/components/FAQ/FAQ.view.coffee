{div, h2, ul, li} = React.DOM

_ = require 'lodash'

# Defines what is required for this module to render
hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('faq')
  true

module.exports = React.createClass
  displayName: 'FAQ'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide
    questions = @props.guide.get('faq')

    div {className: 'guide-module guide-module-faq'},
      h2 {className: 'guide-module-header'}, 'faq'
      ul {},
        questions.map (question, idx) ->
          li {key: "item#{idx}"}, question

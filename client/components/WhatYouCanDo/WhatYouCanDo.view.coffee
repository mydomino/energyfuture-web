{div, h2, p} = React.DOM

_ = require 'lodash'
CallToAction = require '../CallToAction/CallToAction.view'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.get('whatYouCanDo')
  true

module.exports = React.createClass
  displayName: 'whatYouCanDo'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide
    whatYouCanDo = @props.guide.get('whatYouCanDo')

    div {},
      h2 {className: "guide-module-header"}, "What you can do"
      p {className: "guide-module-subheader"}, whatYouCanDo.subheading
      div {className: 'guide-module-content'},
        new CallToAction(actions: whatYouCanDo.cta)

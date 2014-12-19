{div, h2, p} = React.DOM

_ = require 'lodash'
CallToAction = require '../CallToAction/CallToAction.view'

module.exports = React.createClass
  displayName: 'whatYouCanDo'

  getDefaultProps: ->
    guide: null

  render: ->
    whatYouCanDo = @props.content
    return false if _.isEmpty whatYouCanDo

    div {},
      h2 {className: "guide-module-header"}, (whatYouCanDo.heading || "What you can do")
      p {className: "guide-module-subheader"}, whatYouCanDo.subheading
      div {className: 'guide-module-content'},
        new CallToAction(actions: whatYouCanDo.cta)

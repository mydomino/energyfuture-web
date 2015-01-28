React = require 'react'
{div, h2, p} = React.DOM

_ = require 'lodash'
TakeAction = require '../TakeAction/TakeAction.view'

whatYouCanDo = React.createClass
  displayName: 'whatYouCanDo'

  getDefaultProps: ->
    guide: null

  render: ->
    whatYouCanDo = @props.content
    return false if _.isEmpty whatYouCanDo

    div {},
      h2 {className: "guide-module-header"}, (whatYouCanDo.heading or "What you can do")
      p {className: "guide-module-subheader"}, whatYouCanDo.subheading
      div {className: 'guide-module-content'},
        new TakeAction(actions: whatYouCanDo.cta)

module.exports = React.createFactory whatYouCanDo

{div, h2, p} = React.DOM
_ = require 'lodash'

module.exports = React.createClass
  displayName: 'Tips'
  getDefaultProps: ->
    tips: []

  render: ->
    return false if _.isEmpty @props.tips
    div {className: "tips"},
      h2 {className: "tips-header"}, "local tips"
      p {className: "tips-subheader"}, "Have a suggestion? Add a tip"
      div {className: "tip-items"},
        _.map @props.tips, (t) ->
          div {className: "tip"},
            p {className: "tip-content"}, t.get('content')
        div {className: "clear"}

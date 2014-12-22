{div, p} = React.DOM
_ = require 'lodash'
Autolinker = require 'autolinker'

module.exports = React.createClass
  displayName: 'Text'

  render: ->
    text = @props.content
    return false if _.isEmpty text

    div {className: 'guide-module guide-module-text'},
      div {className: 'guide-module-content'},
        p {className: 'text-content', dangerouslySetInnerHTML: {"__html": Autolinker.link(text)}}

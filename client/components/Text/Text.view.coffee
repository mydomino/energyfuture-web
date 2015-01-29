{div, h2, p} = React.DOM
_ = require 'lodash'
Autolinker = require 'autolinker'

module.exports = React.createClass
  displayName: 'Text'

  render: ->
    if typeof @props.content == 'string'
      text = @props.content
    else
      {heading, text} = @props.content

    return false if _.isEmpty text

    div {className: 'guide-module guide-module-text'},
      if heading
        h2 {className: 'guide-module-header'}, heading
      div {className: 'guide-module-content'},
        p {className: 'text-content', dangerouslySetInnerHTML: {"__html": Autolinker.link(text)}}

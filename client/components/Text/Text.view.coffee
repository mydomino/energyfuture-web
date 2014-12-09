{div, p} = React.DOM
_ = require 'lodash'
Autolinker = require 'autolinker'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('text')
  true

module.exports = React.createClass
  displayName: 'Text'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide
    text = @props.guide.get('text')

    div {className: 'guide-module guide-module-text'},
      div {className: 'guide-module-content'},
        p {className: 'text-content', dangerouslySetInnerHTML: {"__html": Autolinker.link(text)}}

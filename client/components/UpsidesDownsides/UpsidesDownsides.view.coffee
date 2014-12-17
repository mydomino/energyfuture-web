{div, ul, li, h2} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

hasValidData = (content) ->
  return false unless content
  return false if _.isEmpty content.upsides
  return false if _.isEmpty content.downsides
  true

module.exports = React.createClass
  displayName: 'UpsidesDownsides'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.moduleContent
    {upsides, downsides} = @props.moduleContent

    div {className: "guide-module guide-module-upsidesdownsides"},
      ul {className: "upside"},
        h2 {}, "upside"
        upsides.map (upside, idx) ->
          li {key: "item#{idx}", dangerouslySetInnerHTML: {"__html": Autolinker.link(upside)}}
      ul {className: "downside"},
        h2 {}, "downside"
        downsides.map (downside, idx) ->
          li {key: "item#{idx}", dangerouslySetInnerHTML: {"__html": Autolinker.link(downside)}}
      div {className: "clear-both"}

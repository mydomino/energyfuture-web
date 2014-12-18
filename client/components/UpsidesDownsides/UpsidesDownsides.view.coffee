{div, ul, li, h2} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

# Defines what is required for this module to render
hasValidData = (guide) ->
  return false unless guide
  return false unless guide.get('upsides')
  return false unless guide.get('downsides')
  true

module.exports = React.createClass
  displayName: 'UpsidesDownsides'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide
    {upsides, downsides} = @props.guide.attributes

    div {className: "guide-module guide-module-upsidesdownsides"},
      ul {className: "upside"},
        h2 {className: "guide-module-header"}, "upside"
        div {className: 'guide-module-content'},
          upsides.map (upside, idx) ->
            li {key: "item#{idx}", dangerouslySetInnerHTML: {"__html": Autolinker.link(upside)}}
      ul {className: "downside"},
        h2 {className: "guide-module-header"}, "downside"
        div {className: 'guide-module-content'},
          downsides.map (downside, idx) ->
            li {key: "item#{idx}", dangerouslySetInnerHTML: {"__html": Autolinker.link(downside)}}
      div {className: "clear-both"}

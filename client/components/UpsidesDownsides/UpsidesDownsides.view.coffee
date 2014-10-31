{div, ul, li, h2} = React.DOM

_ = require 'lodash'
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
        h2 {}, "upside"
        upsides.map (upside, idx) ->
          li {key: "item#{idx}"}, upside
      ul {className: "downside"},
        h2 {}, "downside"
        downsides.map (downside, idx) ->
          li {key: "item#{idx}"}, downside
      div {className: "clear-both"}

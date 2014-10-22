{div, ul, li, h2} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

module.exports = React.createClass
  displayName: 'UpsideDownside'

  getDefaultProps: ->
    upsides: []
    downsides: []

  render: ->
    if _.isEmpty(@props.upsides) && _.isEmpty(@props.downsides)
      return false
    else
      div {className: "upside-downside"},
        ul {className: "upside"},
          h2 {}, "upside"
          _.map @props.upsides, (upside) ->
            li {}, upside
        ul {className: "downside"},
          h2 {}, "downside"
          _.map @props.downsides, (downside) ->
            li {}, downside
        div {className: "clear-both"}

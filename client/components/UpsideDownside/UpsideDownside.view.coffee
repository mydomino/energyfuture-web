{div, ul, li, h2} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

module.exports = React.createClass
  displayName: 'UpsideDownside'

  getDefaultProps: ->
    upsides: []
    downsides: []

  render: ->
    div {className: "upside-downside"},
      ul {className: "upside"},
        h2 {className: "upside-header"}, "upside"
        _.map @props.upsides, (upside) ->
          li {}, upside

{span, select, option} = React.DOM
_ = require 'lodash'

module.exports = React.createClass
  displayName: 'Dropdown'
  render: ->
    span {className: "dropdown-component"},
      select {},
        _.map @props.data, (entry) ->
          option {value: entry.value}, entry.name

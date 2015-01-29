{span, select, option} = React.DOM
_ = require 'lodash'

module.exports = React.createClass
  displayName: 'Dropdown'

  changeAction: (event) ->
    return false unless @props.changeAction
    value = event.target.value
    @props.changeAction(value)

  render: ->
    span {className: "dropdown-component"},
      select {onChange: @changeAction, value: @props.selectedOption},
        _.map @props.data, (entry, index) ->
          option {key: "#{entry.value}-#{index}", value: entry.value}, entry.name

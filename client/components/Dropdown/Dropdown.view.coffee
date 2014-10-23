{span, select, option} = React.DOM
_ = require 'lodash'

module.exports = React.createClass
  displayName: 'Dropdown'

  getDefaultProps: ->
    lightBackground: false

  render: ->
    backgroundClass = if @props.lightBackground then "light" else ""
    span {className: "dropdown-component #{backgroundClass}"},
      select {className: backgroundClass},
        _.map @props.data, (entry) ->
          option {value: entry.value}, entry.name

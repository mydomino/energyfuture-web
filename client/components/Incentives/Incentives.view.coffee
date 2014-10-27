{div, h2, p, a} = React.DOM

_ = require 'lodash'

module.exports = React.createClass
  displayName: 'Incentives'

  render: ->
    div {},
      h2 {className: "incentive-header"}, "incentives"
      div {className: 'incentives'},
        _.map @props.incentives, (i) ->
          div {className: "incentive"},
            p {className: "incentive-provider"}, i.provider
            p {className: "incentive-currency"}, "$"
            p {className: "incentive-amount"}, i.amount
            p {className: "incentive-type"}, i.type
            p {className: "incentive-description"}, i.description
            a {href: i.reference, className: "incentive-reference"}, "learn more"

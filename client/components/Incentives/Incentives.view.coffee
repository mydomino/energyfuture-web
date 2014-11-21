{div, h2, p, a} = React.DOM

_ = require 'lodash'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.get('incentives')
  true

module.exports = React.createClass
  displayName: 'Incentives'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide
    incentives = @props.guide.get('incentives')

    div {},
      h2 {className: "guide-module-header"}, "incentives"
      div {className: 'incentives'},
        _.map incentives, (i) ->
          div {className: "incentive"},
            p {className: "incentive-provider"}, i.provider
            p {className: "incentive-amount"}, i.amount if i.amount
            p {className: "incentive-type"}, i.type if i.type
            p {className: "incentive-description"}, i.description
            a {href: i.reference, className: "incentive-reference"}, "learn more" if i.reference

      div {className: 'clear-both'}

{div, p, a} = React.DOM

module.exports = React.createClass
  displayName: 'IncentiveModal'

  getDefaultProps: ->
    incentive: {}

  render: ->
    i = @props.incentive

    div {className: "incentive-modal"},
      div {className: "incentive"},
        a {className: 'close-icon', onClick: @props.onClose}, 'X'

        p {className: "incentive-provider"}, i.provider

        if i.amount
          p {className: "incentive-amount"}, i.amount

        if i.type
          p {className: "incentive-type"}, i.type

        p {className: "incentive-description"}, i.description
        a {href: i.reference, className: "incentive-reference"}, "learn more" if i.reference

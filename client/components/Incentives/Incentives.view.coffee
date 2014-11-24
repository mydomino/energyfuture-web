{div, h2, p, a} = React.DOM

_ = require 'lodash'
IncentiveModal = require '../IncentiveModal/IncentiveModal.view'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.get('incentives')
  true

module.exports = React.createClass
  displayName: 'Incentives'

  getInitialState: ->
    modalIncentive: null

  getDefaultProps: ->
    guide: null

  showModal: (i) ->
    @setState modalIncentive: i

  render: ->
    return false unless hasValidData @props.guide
    incentives = @props.guide.get('incentives')

    div {},
      h2 {className: "guide-module-header"}, "incentives"

      if @state.modalIncentive
        div {},
          new IncentiveModal
            incentive: @state.modalIncentive
            onClose: =>
              @setState modalIncentive: null

      div {className: 'incentives'},
        _.map incentives, (i) =>
          div {className: "incentive", onClick: @showModal.bind(@, i)},
            p {className: "incentive-provider"}, i.provider

            if i.amount
              p {className: "incentive-amount"}, i.amount

            if i.type
              p {className: "incentive-type"}, i.type

            p {className: "incentive-description"}, i.description
            a {href: i.reference, className: "incentive-reference"}, "learn more" if i.reference

      div {className: 'clear-both'}

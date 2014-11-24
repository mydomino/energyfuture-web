{div, h2, p, a, span} = React.DOM

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

  truncateDescription: (description) ->
    description.slice(0, 100) + "…"

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
          div {className: "incentive"},
            p {className: "incentive-provider"}, i.provider

            if i.amount
              p {className: "incentive-amount"}, i.amount

            if i.type
              p {className: "incentive-type"}, i.type

            p {className: "incentive-description"}, @truncateDescription(i.description)

            if i.reference
              a {href: i.reference, className: "incentive-reference", target: "_blank"},
                "learn more"
            else
              a {className: "incentive-reference", onClick: @showModal.bind(@, i)},
                "learn more"

      div {className: 'clear-both'}

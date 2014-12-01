{div, h2, p, a, span} = React.DOM

_ = require 'lodash'
IncentiveModal = require '../IncentiveModal/IncentiveModal.view'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.get('incentives')
  true

CutLength = 90

module.exports = React.createClass
  displayName: 'Incentives'

  getInitialState: ->
    modalIncentive: null

  getDefaultProps: ->
    guide: null

  showModal: (i) ->
    @setState modalIncentive: i

  descriptionFits: (description) ->
    d = description.slice(0, CutLength)
    return false if d.length < description.length
    true

  truncateDescription: (description) ->
    d = description.slice(0, CutLength)
    wordBoundary = d.lastIndexOf(' ')
    "#{d.slice(0, wordBoundary)} #{String.fromCharCode(8230)}"

  render: ->
    return false unless hasValidData @props.guide
    incentives = @props.guide.get('incentives')

    div {},
      h2 {className: "guide-module-header"}, "incentives"

      if @state.modalIncentive?
        div {},
          new IncentiveModal
            incentive: @state.modalIncentive
            onClose: =>
              @setState modalIncentive: null

      div {className: 'guide-module-content'},
        div {className: 'incentives'},
          _.map incentives, (i) =>
            div {className: "incentive"},
              p {className: "incentive-provider"}, i.provider

              if i.amount
                p {className: "incentive-amount"}, i.amount

              if i.type
                p {className: "incentive-type"}, i.type

              if @descriptionFits(i.description)
                p {className: "incentive-description"}, i.description
              else
                div {},
                  p {className: "incentive-description", dangerouslySetInnerHTML: {"__html": @truncateDescription(i.description)}}
                  a {className: "incentive-reference", onClick: @showModal.bind(@, i)}, "more"

      div {className: 'clear-both'}

{div, h2, p, a, span} = React.DOM

_ = require 'lodash'
IncentiveModal = React.createFactory(require '../IncentiveModal/IncentiveModal.view')

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
    incentives = @props.content
    return false if _.isEmpty incentives

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
          _.map incentives, (i, idx) =>
            div {key: "incentive-#{idx}",className: "incentive"},
              p {className: "incentive-provider"}, i.provider

              if i.amount
                p {className: "incentive-amount"}, i.amount

              if i.type
                p {className: "incentive-type"}, i.type

              if @descriptionFits(i.description)
                div {},
                  p {className: "incentive-description"}, i.description
                  a {className: "incentive-reference", href: i.reference, target: '_blank'}, "learn more" if i.reference
              else
                div {},
                  p {className: "incentive-description", dangerouslySetInnerHTML: {"__html": @truncateDescription(i.description)}}
                  a {className: "incentive-reference", onClick: @showModal.bind(@, i)}, "more"

      div {className: 'clear-both'}

React = require 'react'
{div, p, a} = React.DOM

module.exports = React.createClass
  displayName: 'IncentiveModal'

  getDefaultProps: ->
    incentive: {}

  onOverlayClick: (e) ->
    if e.target is @refs.modalOverlay.getDOMNode()
      @props.onClose()
      return false

  setScrolling: (visible) ->
    if visible
      document.body.style.overflow = "hidden"
    else
      document.body.style.overflow = null

  componentWillMount: ->
    @setScrolling(true)

  componentWillUnmount: ->
    @setScrolling(false)

  render: ->
    i = @props.incentive

    div {className: "modal-overlay", ref: "modalOverlay", onClick: @onOverlayClick},
      div {className: "incentive-modal", ref: "incentiveModal"},
        div {className: "incentive"},
          a {className: 'close-icon', onClick: @props.onClose}, 'X'

          p {className: "incentive-provider"}, i.provider

          if i.amount
            p {className: "incentive-amount"}, i.amount

          if i.type
            p {className: "incentive-type"}, i.type

          p {className: "incentive-description"}, i.description
          a {href: i.reference, className: "incentive-reference"}, "learn more" if i.reference

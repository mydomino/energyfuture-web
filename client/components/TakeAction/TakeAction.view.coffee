{div, h2, p, a, img} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

showMore = (event) ->
  $(event.target).parents('.action').css('max-height', 'none')
  $(event.target).parent('.action-read-more').hide()

module.exports = React.createClass
  displayName: 'TakeAction'

  getDefaultProps: ->
    actions: {}

  componentDidMount: ->
    $(".guide-actions .action").each (_, action) ->
      if $(action).outerHeight() >= 240
        $(action).find('.action-read-more').show()

  render: ->
    actions = @props.actions

    div {className: 'guide-actions'},
      _.map actions, (action, idx) ->
        div {key: "action-#{idx}", className: "action"},
          h2 {className: "action-grouping"}, action.grouping
          a {href: action.reference, className: "action-title", target: "_blank"}, action.title
          p {className: "action-description", dangerouslySetInnerHTML: {"__html": Autolinker.link(action.description)}}
          div {className: 'action-read-more'},
            img {className : 'action-read-more-button', src: '/img/show-more.svg', onClick: showMore}
            div {className: 'action-read-more-mask'}
      div {className: "clear-both"}

{div, h2, p, a, img} = React.DOM

_ = require 'lodash'

showMore = (event) ->
  $(event.target).parents('.action').css('max-height', 'none')
  $(event.target).parent('.action-read-more').hide()

module.exports = React.createClass
  displayName: 'CallToAction'

  getDefaultProps: ->
    actions: {}

  componentDidMount: ->
    $(".guide-actions .action").each (_, action) ->
      if $(action).outerHeight() >= 240
        $(action).find('.action-read-more').show()

  render: ->
    actions = @props.actions

    div {className: 'guide-actions'},
      _.map actions, (action) ->
        div {className: "action"},
          h2 {className: "action-grouping"}, action.grouping
          a {href: action.reference, className: "action-title", target: "_blank"}, action.title
          p {className: "action-description"}, action.description
          div {className: 'action-read-more'},
            img {className : 'action-read-more-button', src: '/img/show-more.svg', onClick: showMore}
            div {className: 'action-read-more-mask'}
      div {className: "clear-both"}
